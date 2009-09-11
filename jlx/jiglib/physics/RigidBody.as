﻿/*
   Copyright (c) 2007 Danny Chapman
   http://www.rowlhouse.co.uk

   This software is provided 'as-is', without any express or implied
   warranty. In no event will the authors be held liable for any damages
   arising from the use of this software.
   Permission is granted to anyone to use this software for any purpose,
   including commercial applications, and to alter it and redistribute it
   freely, subject to the following restrictions:
   1. The origin of this software must not be misrepresented; you must not
   claim that you wrote the original software. If you use this software
   in a product, an acknowledgment in the product documentation would be
   appreciated but is not required.
   2. Altered source versions must be plainly marked as such, and must not be
   misrepresented as being the original software.
   3. This notice may not be removed or altered from any source
   distribution.
 */

/**
 * @author Muzer(muzerly@gmail.com)
 * @link http://code.google.com/p/jiglibflash
 */

package jiglib.physics
{
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	
	import jiglib.cof.JConfig;
	import jiglib.collision.CollisionInfo;
	import jiglib.geometry.JSegment;
	import jiglib.math.JMatrix3D;
	import jiglib.math.JNumber3D;
	import jiglib.physics.constraint.JConstraint;
	import jiglib.plugin.ISkin3D;

	public class RigidBody
	{
		private static var idCounter:int = 0;

		private var _id:int;
		private var _skin:ISkin3D;

		protected var _type:String;
		protected var _boundingSphere:Number;

		protected var _currState:PhysicsState;
		private var _oldState:PhysicsState;
		private var _storeState:PhysicsState;
		private var _invOrientation:Matrix3D;
		private var _currLinVelocityAux:Vector3D;
		private var _currRotVelocityAux:Vector3D;

		private var _mass:Number;
		private var _invMass:Number;
		private var _bodyInertia:Matrix3D;
		private var _bodyInvInertia:Matrix3D;
		private var _worldInertia:Matrix3D;
		private var _worldInvInertia:Matrix3D;

		private var _force:Vector3D;
		private var _torque:Vector3D;

		private var _velChanged:Boolean;
		private var _activity:Boolean;
		private var _movable:Boolean;
		private var _origMovable:Boolean;
		private var _inactiveTime:Number;

		private var _bodiesToBeActivatedOnMovement:Vector.<RigidBody>;

		private var _storedPositionForActivation:Vector3D;
		private var _lastPositionForDeactivation:Vector3D;
		private var _lastOrientationForDeactivation:JMatrix3D;

		private var _material:MaterialProperties;

		private var _rotationX:Number = 0;
		private var _rotationY:Number = 0;
		private var _rotationZ:Number = 0;
		private var _useDegrees:Boolean;

		private var _nonCollidables:Vector.<RigidBody>;
		private var _constraints:Vector.<JConstraint>;
		public var collisions:Vector.<CollisionInfo>;

		public function RigidBody(skin:ISkin3D)
		{
			_useDegrees = (JConfig.rotationType == "DEGREES") ? true : false;

			_id = idCounter++;

			_skin = skin;
			_material = new MaterialProperties();

			_bodyInertia = JMatrix3D.getMatrix3D(JMatrix3D.IDENTITY);
			_bodyInvInertia = (JMatrix3D.getInverseMatrix((_bodyInertia)));

			_currState = new PhysicsState();
			_oldState = new PhysicsState();
			_storeState = new PhysicsState();
			//_invOrientation = JMatrix3D.inverse(_currState.orientation);
			_invOrientation = JMatrix3D.getInverseMatrix(_currState.__orientation);
			_currLinVelocityAux = new Vector3D();
			_currRotVelocityAux = new Vector3D();

			_force = new Vector3D();
			_torque = new Vector3D();

			_velChanged = false;
			_inactiveTime = 0;

			isActive = _activity = true;
			_movable = true;
			_origMovable = true;

			collisions = new Vector.<CollisionInfo>();
			_constraints = new Vector.<JConstraint>();
			_nonCollidables = new Vector.<RigidBody>();

			_storedPositionForActivation = new Vector3D();
			_bodiesToBeActivatedOnMovement = new Vector.<RigidBody>();
			_lastPositionForDeactivation = _currState.position.clone();
			_lastOrientationForDeactivation = JMatrix3D.clone(_currState.orientation);

			_type = "Object3D";
			_boundingSphere = 0;
		}

		private function radiansToDegrees(rad:Number):Number
		{
			return rad * 180 / Math.PI;
		}

		private function degreesToRadians(deg:Number):Number
		{
			return deg * Math.PI / 180;
		}

		public function get rotationX():Number
		{
			return (_useDegrees) ? radiansToDegrees(_rotationX) : _rotationX;
		}

		public function get rotationY():Number
		{
			return (_useDegrees) ? radiansToDegrees(_rotationY) : _rotationY;
		}

		public function get rotationZ():Number
		{
			return (_useDegrees) ? radiansToDegrees(_rotationZ) : _rotationZ;
		}

		/**
		 * px - angle in Radians or Degrees
		 */
		public function set rotationX(px:Number):void
		{
			var rad:Number = (_useDegrees) ? degreesToRadians(px) : px;
			_rotationX = rad;
			setOrientation(createRotationMatrix());
		}

		/**
		 * py - angle in Radians or Degrees
		 */
		public function set rotationY(py:Number):void
		{
			var rad:Number = (_useDegrees) ? degreesToRadians(py) : py;
			_rotationY = rad;
			setOrientation(createRotationMatrix());
		}

		/**
		 * pz - angle in Radians or Degrees
		 */
		public function set rotationZ(pz:Number):void
		{
			var rad:Number = (_useDegrees) ? degreesToRadians(pz) : pz;
			_rotationZ = rad;
			setOrientation(createRotationMatrix());
		}

		public function pitch(rot:Number):void
		{
			//var rad:Number = (_useDegrees) ? degreesToRadians(rot) : rot;
			//setOrientation(JMatrix3D.multiply(currentState.orientation, JMatrix3D.rotationX(rot)));
		}

		public function yaw(rot:Number):void
		{
			//var rad:Number = (_useDegrees) ? degreesToRadians(rot) : rot;
			//setOrientation(JMatrix3D.multiply(currentState.orientation, JMatrix3D.rotationY(rot)));
		}

		public function roll(rot:Number):void
		{
			//var rad:Number = (_useDegrees) ? degreesToRadians(rot) : rot;
			//setOrientation(JMatrix3D.multiply(currentState.orientation, JMatrix3D.rotationZ(rot)));
		}
/*
		private function createRotationMatrix():JMatrix3D
		{
			var rx:JMatrix3D = JMatrix3D.rotationX(_rotationX);
			var ry:JMatrix3D = JMatrix3D.rotationY(_rotationY);
			var rz:JMatrix3D = JMatrix3D.rotationZ(_rotationZ);
			var um:JMatrix3D = JMatrix3D.multiply(rx, ry);
			um = JMatrix3D.multiply(um, rz);
			return um;
		}
*/
		private function createRotationMatrix():Matrix3D
		{
			var matrix3d:Matrix3D = new Matrix3D();
			matrix3d.appendRotation(_rotationX, Vector3D.X_AXIS);
			matrix3d.appendRotation(_rotationY, Vector3D.Y_AXIS);
			matrix3d.appendRotation(_rotationZ, Vector3D.Z_AXIS);
			return matrix3d;
		}
/*
		public function setOrientation(_orient:Matrix3D):void
		{
			var orient:JMatrix3D = JMatrix3D.getJMatrix3D(_orient);
			
			_currState.orientation.copy(orient);
			_invOrientation = JMatrix3D.getTransposeMatrix(_currState.__orientation);
			_worldInertia = JMatrix3D.multiply(JMatrix3D.multiply(_currState.orientation, _bodyInertia),  JMatrix3D.getJMatrix3D(_invOrientation));
			_worldInvInertia = JMatrix3D.multiply(JMatrix3D.multiply(_currState.orientation, _bodyInvInertia), JMatrix3D.getJMatrix3D(_invOrientation));
			updateState();
		}
*/

		public function setOrientation(orient:Matrix3D):void
		{
			_currState.orientation = JMatrix3D.getJMatrix3D(orient.clone());
			updateInertia();
			updateState();
		}
		
		public function get x():Number
		{
			return _currState.position.x;
		}

		public function get y():Number
		{
			return _currState.position.y;
		}

		public function get z():Number
		{
			return _currState.position.z;
		}

		public function set x(px:Number):void
		{
			_currState.position.x = px;
			updateState();
		}

		public function set y(py:Number):void
		{
			_currState.position.y = py;
			updateState();
		}

		public function set z(pz:Number):void
		{
			_currState.position.z = pz;
			updateState();
		}

		public function moveTo(pos:Vector3D):void
		{
			_currState.position = pos.clone();
			updateState();
		}

		protected function updateState():void
		{
			_currState.linVelocity = new Vector3D();
			_currState.rotVelocity = new Vector3D();
			copyCurrentStateToOld();
		}

		public function setVelocity(vel:Vector3D):void
		{
			_currState.linVelocity = vel.clone();
		}

		public function setAngVel(angVel:Vector3D):void
		{
			_currState.rotVelocity = angVel.clone();
		}

		public function setVelocityAux(vel:Vector3D):void
		{
			_currLinVelocityAux = vel.clone();
		}

		public function setAngVelAux(angVel:Vector3D):void
		{
			_currRotVelocityAux = angVel.clone();
		}

		public function addGravity():void
		{
			if (!_movable)
			{
				return;
			}
			_force = _force.add(JNumber3D.getScaleVector(PhysicsSystem.getInstance().gravity, _mass));
			_velChanged = true;
		}

		public function addExternalForces(dt:Number):void
		{
			addGravity();
		}

		public function addWorldTorque(t:Vector3D):void
		{
			if (!_movable)
			{
				return;
			}
			_torque = _torque.add(t);
			_velChanged = true;
			setActive();
		}

		public function addBodyTorque(t:Vector3D):void
		{
			if (!_movable)
			{
				return;
			}
			JMatrix3D.multiplyVector(_currState.orientation, t);
			addWorldTorque(t);
		}

		public function addWorldForce(f:Vector3D, p:Vector3D):void
		{
			if (!_movable)
			{
				return;
			}
			_force = _force.add(f);
	        //addWorldTorque(JNumber3D.cross(f, JNumber3D.sub(p, _currState.position)));
			addWorldTorque(p.subtract(_currState.position).crossProduct(f));
			_velChanged = true;
			setActive();
		}

		public function addBodyForce(f:Vector3D, p:Vector3D):void
		{
			if (!_movable)
			{
				return;
			}
			JMatrix3D.multiplyVector(_currState.orientation, f);
			JMatrix3D.multiplyVector(_currState.orientation, p);
			addWorldForce(f, _currState.position.add(p));
		}

		public function clearForces():void
		{
			_force = new Vector3D();
			_torque = new Vector3D();
		}

		public function applyWorldImpulse(impulse:Vector3D, pos:Vector3D):void
		{
			if (!_movable)
			{
				return;
			}
			_currState.linVelocity = _currState.linVelocity.add(JNumber3D.getScaleVector(impulse, _invMass));
			//var rotImpulse:JNumber3D = JNumber3D.cross(impulse, JNumber3D.sub(pos, _currState.position));
			var rotImpulse:Vector3D = pos.subtract(_currState.position).crossProduct(impulse);
			JMatrix3D.multiplyVector(_worldInvInertia, rotImpulse);
			_currState.rotVelocity = _currState.rotVelocity.add(rotImpulse);

			_velChanged = true;
		}

		public function applyWorldImpulseAux(impulse:Vector3D, pos:Vector3D):void
		{
			if (!_movable)
			{
				return;
			}
			_currLinVelocityAux = _currLinVelocityAux.add(JNumber3D.getScaleVector(impulse, _invMass));

			var rotImpulse:Vector3D = pos.subtract(_currState.position).crossProduct(impulse);
			JMatrix3D.multiplyVector(_worldInvInertia, rotImpulse);
			_currRotVelocityAux = _currRotVelocityAux.add(rotImpulse);

			_velChanged = true;
		}

		public function applyBodyWorldImpulse(impulse:Vector3D, delta:Vector3D):void
		{
			if (!_movable)
			{
				return;
			}
			_currState.linVelocity = _currState.linVelocity.add(JNumber3D.getScaleVector(impulse, _invMass));

			var rotImpulse:Vector3D = delta.crossProduct(impulse);
			JMatrix3D.multiplyVector(_worldInvInertia, rotImpulse);
			_currState.rotVelocity = _currState.rotVelocity.add(rotImpulse);

			_velChanged = true;
		}

		public function applyBodyWorldImpulseAux(impulse:Vector3D, delta:Vector3D):void
		{
			if (!_movable)
			{
				return;
			}
			_currLinVelocityAux = _currLinVelocityAux.add(JNumber3D.getScaleVector(impulse, _invMass));

			var rotImpulse:Vector3D = delta.crossProduct(impulse);
			JMatrix3D.multiplyVector(_worldInvInertia, rotImpulse);
			_currRotVelocityAux = _currRotVelocityAux.add(rotImpulse);

			_velChanged = true;
		}

		public function addConstraint(constraint:JConstraint):void
		{
			if (!findConstraint(constraint))
			{
				_constraints.push(constraint);
			}
		}

		public function removeConstraint(constraint:JConstraint):void
		{
			if (findConstraint(constraint))
			{
				_constraints.splice(_constraints.indexOf(constraint), 1);
			}
		}

		public function removeAllConstraints():void
		{
			_constraints = new Vector.<JConstraint>();
		}

		private function findConstraint(constraint:JConstraint):Boolean
		{
			for each (var _constraint:JConstraint in _constraints)
			{
				if (constraint == _constraint)
				{
					return true;
				}
			}
			return false;
		}

		public function updateVelocity(dt:Number):void
		{
			if (!_movable || !_activity)
			{
				return;
			}
			_currState.linVelocity = _currState.linVelocity.add(JNumber3D.getScaleVector(_force, _invMass * dt));

			var rac:Vector3D = JNumber3D.getScaleVector(_torque, dt);
			JMatrix3D.multiplyVector(_worldInvInertia, rac);
			_currState.rotVelocity = _currState.rotVelocity.add(rac);

			var damping:Number = JConfig.damping;
			_currState.linVelocity = JNumber3D.getScaleVector(_currState.linVelocity, damping);
			_currState.rotVelocity = JNumber3D.getScaleVector(_currState.rotVelocity, damping);
		}

		public function updatePosition(dt:Number):void
		{
			if (!_movable || !_activity)
			{
				return;
			}

			var angMomBefore:Vector3D = _currState.rotVelocity.clone();
			JMatrix3D.multiplyVector(_worldInertia, angMomBefore);

			_currState.position = _currState.position.add(JNumber3D.getScaleVector(_currState.linVelocity, dt));

			var dir:Vector3D = _currState.rotVelocity.clone();
			var ang:Number = dir.length;
			if (ang > 0)
			{
				dir.normalize();
				ang *= dt;
				var rot:JMatrix3D = JMatrix3D.rotationMatrix(dir.x, dir.y, dir.z, ang);
				_currState.orientation = JMatrix3D.multiply(rot, _currState.orientation);

				_invOrientation = JMatrix3D.getTransposeMatrix(_currState.__orientation);
				_worldInertia = JMatrix3D.getMatrix3D(JMatrix3D.multiply(JMatrix3D.multiply(_currState.orientation, JMatrix3D.getJMatrix3D(_bodyInertia)), JMatrix3D.getJMatrix3D(_invOrientation)));
				_worldInvInertia = JMatrix3D.getMatrix3D(JMatrix3D.multiply(JMatrix3D.multiply(_currState.orientation, JMatrix3D.getJMatrix3D(_bodyInvInertia)), JMatrix3D.getJMatrix3D(_invOrientation)));
			}

			JMatrix3D.multiplyVector(_worldInvInertia, angMomBefore);
			_currState.rotVelocity = angMomBefore.clone();
		}

		public function updatePositionWithAux(dt:Number):void
		{
			if (!_movable || !_activity)
			{
				_currLinVelocityAux = new Vector3D();
				_currRotVelocityAux = new Vector3D();
				return;
			}
			var ga:int = PhysicsSystem.getInstance().gravityAxis;
			if (ga != -1)
			{
				var arr:Array = JNumber3D.toArray(_currLinVelocityAux);
				arr[(ga + 1) % 3] *= 0.1;
				arr[(ga + 2) % 3] *= 0.1;
				JNumber3D.copyFromArray(_currLinVelocityAux, arr);
			}

			var angMomBefore:Vector3D = _currState.rotVelocity.clone();
			JMatrix3D.multiplyVector(_worldInertia, angMomBefore);

			_currState.position = _currState.position.add(JNumber3D.getScaleVector(_currState.linVelocity.add(_currLinVelocityAux), dt));

			var dir:Vector3D = _currState.rotVelocity.add(_currRotVelocityAux);
			var ang:Number = dir.length;
			if (ang > 0)
			{
				dir.normalize();
				ang *= dt;
				var rot:JMatrix3D = JMatrix3D.rotationMatrix(dir.x, dir.y, dir.z, ang);
				_currState.orientation = JMatrix3D.multiply(rot, _currState.orientation);
				
				_invOrientation = JMatrix3D.getTransposeMatrix(_currState.__orientation);
				_worldInertia = JMatrix3D.getMatrix3D(JMatrix3D.multiply(JMatrix3D.multiply(_currState.orientation, JMatrix3D.getJMatrix3D(_bodyInertia)), JMatrix3D.getJMatrix3D(_invOrientation)));
				_worldInvInertia = JMatrix3D.getMatrix3D(JMatrix3D.multiply(JMatrix3D.multiply(_currState.orientation, JMatrix3D.getJMatrix3D(_bodyInvInertia)), JMatrix3D.getJMatrix3D(_invOrientation)));
			}
			_currLinVelocityAux = new Vector3D();
			_currRotVelocityAux = new Vector3D();

			JMatrix3D.multiplyVector(_worldInvInertia, angMomBefore);
			_currState.rotVelocity = angMomBefore.clone();
		}

		public function postPhysics(dt:Number):void
		{
		}

		public function tryToFreeze(dt:Number):void
		{
			if (!_movable || !_activity)
			{
				return;
			}
			if (_currState.position.subtract(_lastPositionForDeactivation).length > JConfig.posThreshold)
			{
				_lastPositionForDeactivation = _currState.position.clone();
				_inactiveTime = 0;
				return;
			}

			var ot:Number = JConfig.orientThreshold;
			var deltaMat:JMatrix3D = JMatrix3D.getJMatrix3D(JMatrix3D.getPrependMatrix(JMatrix3D.getMatrix3D(_currState.orientation), JMatrix3D.getMatrix3D(_lastOrientationForDeactivation)));
			var deltaMatCols:* = deltaMat.getCols();
			if (deltaMatCols[0].length > ot || deltaMatCols[1].length > ot || deltaMatCols[2].length > ot)
			{

				_lastOrientationForDeactivation.copy(_currState.orientation);
				_inactiveTime = 0;
				return;
			}
			if (getShouldBeActive())
			{
				return;
			}
			_inactiveTime += dt;
			if (_inactiveTime > JConfig.deactivationTime)
			{
				_lastPositionForDeactivation = _currState.position.clone();
				_lastOrientationForDeactivation.copy(_currState.orientation);
				setInactive();
			}
		}

		public function set mass(m:Number):void
		{
			_mass = m;
			_invMass = 1 / m;
			setInertia(getInertiaProperties(m));
		}

		public function setInertia(i:*):void
		{
			if(i is JMatrix3D)
			{
				
			}else{
				i = JMatrix3D.getJMatrix3D(i);
			}
			
			_bodyInertia = JMatrix3D.getMatrix3D(JMatrix3D.clone(i));
			_bodyInvInertia = (JMatrix3D.getInverseMatrix(JMatrix3D.getMatrix3D(i)));

			_worldInertia = JMatrix3D.getMatrix3D(JMatrix3D.multiply(JMatrix3D.multiply(_currState.orientation, JMatrix3D.getJMatrix3D(_bodyInertia)), JMatrix3D.getJMatrix3D(_invOrientation)));
			_worldInvInertia = JMatrix3D.getMatrix3D(JMatrix3D.multiply(JMatrix3D.multiply(_currState.orientation, JMatrix3D.getJMatrix3D(_bodyInvInertia)), JMatrix3D.getJMatrix3D(_invOrientation)));
		}

		public function updateInertia():void
		{
			_invOrientation = JMatrix3D.getTransposeMatrix(_currState.__orientation);
			
			_worldInertia = (JMatrix3D.getAppendMatrix3D
			(
				_invOrientation,
				JMatrix3D.getAppendMatrix3D(_currState.__orientation, (_bodyInertia))
			));

			_worldInvInertia = (JMatrix3D.getAppendMatrix3D
			(
				_invOrientation,
				JMatrix3D.getAppendMatrix3D(_currState.__orientation, _bodyInvInertia)
			));
		}
		
		public var isActive:Boolean;

		public function get movable():Boolean
		{
			return _movable;
		}

		public function set movable(mov:Boolean):void
		{
			_movable = mov;
			isActive = _activity = mov;
			_origMovable = mov;
		}

		public function internalSetImmovable():void
		{
			_origMovable = _movable;
			_movable = false;
		}

		public function internalRestoreImmovable():void
		{
			_movable = _origMovable;
		}

		public function getVelChanged():Boolean
		{
			return _velChanged;
		}

		public function clearVelChanged():void
		{
			_velChanged = false;
		}

		public function setActive(activityFactor:Number = 1):void
		{
			if (_movable)
			{
				isActive = _activity = true;
				_inactiveTime = (1 - activityFactor) * JConfig.deactivationTime;
			}
		}

		public function setInactive():void
		{
			if (_movable)
			{
				isActive = _activity = false;
			}
		}

		public function getVelocity(relPos:Vector3D):Vector3D
		{
			return _currState.linVelocity.add(_currState.rotVelocity.crossProduct(relPos));
		}

		public function getVelocityAux(relPos:Vector3D):Vector3D
		{
			return _currLinVelocityAux.add(_currRotVelocityAux.crossProduct(relPos));
		}

		public function getShouldBeActive():Boolean
		{
			return ((_currState.linVelocity.length > JConfig.velThreshold) || (_currState.rotVelocity.length > JConfig.angVelThreshold));
		}

		public function getShouldBeActiveAux():Boolean
		{
			return ((_currLinVelocityAux.length > JConfig.velThreshold) || (_currRotVelocityAux.length > JConfig.angVelThreshold));
		}

		public function dampForDeactivation():void
		{
			var r:Number = 0.5;
			var frac:Number = _inactiveTime / JConfig.deactivationTime;
			if (frac < r)
			{
				return;
			}

			var scale:Number = 1 - ((frac - r) / (1 - r));
			if (scale < 0)
			{
				scale = 0;
			}
			else if (scale > 1)
			{
				scale = 1;
			}
			_currState.linVelocity = JNumber3D.getScaleVector(_currState.linVelocity, scale);
			_currState.rotVelocity = JNumber3D.getScaleVector(_currState.rotVelocity, scale);
		}

		public function doMovementActivations():void
		{
			if (_bodiesToBeActivatedOnMovement.length == 0 || _currState.position.subtract(_storedPositionForActivation).length < JConfig.posThreshold)
			{
				return;
			}
			for (var i:int = 0; i < _bodiesToBeActivatedOnMovement.length; i++)
			{
				PhysicsSystem.getInstance().activateObject(_bodiesToBeActivatedOnMovement[i]);
			}
			_bodiesToBeActivatedOnMovement = new Vector.<RigidBody>();
		}

		public function addMovementActivation(pos:Vector3D, otherBody:RigidBody):void
		{
			var len:int = _bodiesToBeActivatedOnMovement.length;
			for (var i:int = 0; i < len; i++)
			{
				if (_bodiesToBeActivatedOnMovement[i] == otherBody)
				{
					return;
				}
			}
			if (_bodiesToBeActivatedOnMovement.length == 0)
			{
				_storedPositionForActivation = pos;
			}
			_bodiesToBeActivatedOnMovement.push(otherBody);
		}

		public function setConstraintsAndCollisionsUnsatisfied():void
		{
			for each (var _constraint:JConstraint in _constraints)
			{
				_constraint.satisfied = false;
			}
			for each (var _collision:CollisionInfo in collisions)
			{
				_collision.satisfied = false;
			}
		}

		public function segmentIntersect(out:Object, seg:JSegment, state:PhysicsState):Boolean
		{
			return false;
		}

		public function getInertiaProperties(m:Number):Matrix3D
		{
			return new Matrix3D();
			m;
		}

		public function hitTestObject3D(obj3D:RigidBody):Boolean
		{
			var num1:Number = _currState.position.subtract(obj3D.currentState.position).length;
			var num2:Number = _boundingSphere + obj3D.boundingSphere;

			if (num1 <= num2)
			{
				return true;
			}

			return false;
		}

		private function findNonCollidablesBody(body:RigidBody):Boolean
		{
			for each (var _body:RigidBody in _nonCollidables)
			{
				if (body == _body)
				{
					return true;
				}
			}
			return false;
		}

		public function disableCollisions(body:RigidBody):void
		{
			if (!findNonCollidablesBody(body))
			{
				_nonCollidables.push(body);
			}
		}

		public function enableCollisions(body:RigidBody):void
		{
			if (findNonCollidablesBody(body))
			{
				_nonCollidables.splice(_nonCollidables.indexOf(body), 1);
			}
		}

		public function copyCurrentStateToOld():void
		{
			_oldState.position = _currState.position.clone();
			_oldState.orientation.copy(_currState.orientation);
			_oldState.linVelocity = _currState.linVelocity.clone();
			_oldState.rotVelocity = _currState.rotVelocity.clone();
		}

		public function storeState():void
		{
			_storeState.position = _currState.position.clone();
			_storeState.orientation.copy(_currState.orientation);
			_storeState.linVelocity = _currState.linVelocity.clone();
			_storeState.rotVelocity = _currState.rotVelocity.clone();
		}

		public function restoreState():void
		{
			_currState.position = _storeState.position.clone();
			_currState.orientation.copy(_storeState.orientation);
			_currState.linVelocity = _storeState.linVelocity.clone();
			_currState.rotVelocity = _storeState.rotVelocity.clone();
		}

		public function get currentState():PhysicsState
		{
			return _currState;
		}

		public function get oldState():PhysicsState
		{
			return _oldState;
		}

		public function get id():int
		{
			return _id;
		}

		public function get type():String
		{
			return _type;
		}

		public function get skin():ISkin3D
		{
			return _skin;
		}

		public function get boundingSphere():Number
		{
			return _boundingSphere;
		}

		public function get force():Vector3D
		{
			return _force;
		}

		public function get mass():Number
		{
			return _mass;
		}

		public function get invMass():Number
		{
			return _invMass;
		}

		public function get worldInertia():Matrix3D
		{
			return _worldInertia;
		}

		public function get worldInvInertia():Matrix3D
		{
			return _worldInvInertia;
		}

		public function get nonCollidables():Vector.<RigidBody>
		{
			return _nonCollidables;
		}

		public function limitVel():void
		{
			var maxValue:Number = JConfig.limitLinVelocities;
			_currState.linVelocity.x = JNumber3D.getLimiteNumber(_currState.linVelocity.x, -maxValue, maxValue);
			_currState.linVelocity.y = JNumber3D.getLimiteNumber(_currState.linVelocity.y, -maxValue, maxValue);
			_currState.linVelocity.z = JNumber3D.getLimiteNumber(_currState.linVelocity.z, -maxValue, maxValue);
		}

		public function limitAngVel():void
		{
			var maxValue:Number = JConfig.limitAngVelocities;
			var fx:Number = Math.abs(_currState.rotVelocity.x) / maxValue;
			var fy:Number = Math.abs(_currState.rotVelocity.y) / maxValue;
			var fz:Number = Math.abs(_currState.rotVelocity.z) / maxValue;
			var f:Number = Math.max(fx, fy, fz);
			if (f > 1)
			{
				_currState.rotVelocity = JNumber3D.getDivideVector(_currState.rotVelocity, f);
			}
		}

		public function getTransform():JMatrix3D
		{
			if (_skin != null)
			{
				return _skin.transform;
			}
			else
			{
				return null;
			}
		}

		public function updateObject3D():void
		{
			if (_skin != null)
			{
				var m:JMatrix3D = JMatrix3D.multiply(JMatrix3D.translationMatrix(_currState.position.x, _currState.position.y, _currState.position.z), _currState.orientation);
				_skin.transform = m;
			}
		}

		public function get material():MaterialProperties
		{
			return _material;
		}

		public function get restitution():Number
		{
			return _material.restitution;
		}

		public function set restitution(restitution:Number):void
		{
			_material.restitution = restitution;
		}

		public function get friction():Number
		{
			return _material.friction;
		}

		public function set friction(friction:Number):void
		{
			_material.friction = friction;
		}
	}
}