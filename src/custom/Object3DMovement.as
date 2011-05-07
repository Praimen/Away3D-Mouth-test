package custom
{
	import away3d.containers.*;
	import away3d.core.base.*;
	import away3d.core.utils.*;
	import away3d.events.*;
	
	import com.greensock.*;
	
	import flash.display.*;
	import flash.events.*;
	//import flash.utils.flash_proxy;
	
	
	/*
	This controls the mouse look for 3d objects
	
	*/
	public class Object3DMovement extends Sprite 
	{
		
		private var lastMouseX:Number;
		private var lastMouseY:Number;
		private var restrictX:Number;
		private var restrictY:Number;
		private var currentSelectedMesh:ObjectContainer3D;
		private var currentMeshName:String;
		private var stageDisplay:Stage;
		
		private static var _instance:Object3DMovement;
		
		private var _ini:Init;
		
		
		public function Object3DMovement(stage:Stage,init:Object=null)
		{
			
			stageDisplay = stage;
			_ini = Init.parse(init) as Init;
			restrictX = _ini.getNumber("rotX", 0);
			restrictY = _ini.getNumber("rotY", 0);
		}
		
		/*public function getInstance():Object3DMovement{
		if(_instance == null){
		_instance = new Object3DMovement(new SingletonSentry());
		}
		return _instance	
		
		}*/
		
		public function clickElement(event:MouseEvent3D):void {			
			lastMouseX = mouseX;
			lastMouseY = mouseY;		
			//isClicked = true; 
			//to get the container to rotate instead of the meshes parent.parent is needed
			
			currentSelectedMesh = event.object.parent;
			
			
			//trace(event.object.parent.parent);
			if(currentSelectedMesh != null){
				TweenMax.killTweensOf(currentSelectedMesh);//added
			}
			addEventListener(Event.ENTER_FRAME, mouseLookMovement);			
		}
		
		public function unClickElement(event:MouseEvent3D):void {
			if(currentSelectedMesh != null){
				//currentSelectedMesh.removeOnMouseDown(clickElement);
				//this should be a parameterized option to return back to center
				TweenMax.to(currentSelectedMesh,.5,{rotationY:0, rotationX:0});//added
			}
			
			
			removeEventListener(Event.ENTER_FRAME, mouseLookMovement);			
			
		}		
		
		private function mouseLookMovement(event:Event):void{			
			//trace(event.target );
			var amt:Number;
			var percent:Number;
			
			//left to right movement
			if(mouseX != lastMouseX && mouseX < lastMouseX ){
				
				amt = mouseX - lastMouseX;
				percent = amt / (stageDisplay.stageWidth/2);				
				
				if(currentSelectedMesh.rotationY < restrictY){
					currentSelectedMesh.rotationY -= percent * 360;
					
					
				}else{
					TweenMax.to(currentSelectedMesh,.25,{rotationY:restrictY});
					//currentSelectedMesh.rotationY = 90;					
				}				
				lastMouseX = mouseX;
				//this.view.camera.lookAt(cube.position);
			}
			
			
			//right to left movement
			if(mouseX != lastMouseX && mouseX > lastMouseX ){
				amt = mouseX - lastMouseX;
				percent =  amt / (stageDisplay.stageWidth/2);	
				
				if(currentSelectedMesh.rotationY > -restrictY){
					currentSelectedMesh.rotationY -= percent * 360;
					
					
				}else{
					//currentSelectedMesh.rotationY = -90;	
					TweenMax.to(currentSelectedMesh,.25,{rotationY:-restrictY});
				}
				lastMouseX = mouseX;
				
			}			
			
			// up-down camera movement
			if(mouseY != lastMouseY && mouseY < lastMouseY ){
				amt = mouseY - lastMouseY;
				percent =  amt / (stageDisplay.stageHeight/2)
				
				if(currentSelectedMesh.rotationX > -restrictX){
					currentSelectedMesh.rotationX += percent * 360;
					
				}else{						
					TweenMax.to(currentSelectedMesh,.25,{rotationX:-restrictX});
				}
				lastMouseY = mouseY;
				
			}
			
			
			//down to up movement
			if(mouseY != lastMouseY && mouseY > lastMouseY ){
				amt = mouseY - lastMouseY;
				percent =  amt / (stageDisplay.stageHeight/2);
				//trace(this.currentSelectedMesh.rotationX);
				if(currentSelectedMesh.rotationX < restrictX){
					currentSelectedMesh.rotationX += percent * 360;						
				}else{					
					TweenMax.to(currentSelectedMesh,.25,{rotationX:restrictX});
				}
				lastMouseY = mouseY;
				
			}	
			
			
			
		}
		
		
		public function getRotationX():Number{
			return currentSelectedMesh.rotationX;
		}
		
		public function getRotationY():Number{
			return currentSelectedMesh.rotationY;
		}
		
		
		
	}//end class
}//end package

