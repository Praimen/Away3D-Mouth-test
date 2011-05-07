package{
	import away3d.cameras.*;
	import away3d.containers.ObjectContainer3D;
	import away3d.containers.Scene3D;
	import away3d.containers.View3D;
	import away3d.core.base.*;
	import away3d.core.render.*;
	import away3d.events.*;
	import away3d.lights.*;
	import away3d.materials.*;
	import away3d.primitives.*;
	
	import com.greensock.*;
	
	import custom.*;
	
	import flash.display.*;
	import flash.events.*;
	import flash.geom.*;
	import flash.text.*;
	
	
	
		[SWF(backgroundColor="#666666", frameRate="100", width="800", height="600")]
		
	public class Away3DFlash extends Sprite{
	
		private var scene:Scene3D;		
		private var view:View3D;	
		private var cube:Mouth3D;
		private var realCube:Cube;//BasePanel3D;
		private var currentSelectedMesh:Mesh;
		private var currentMeshName:String;
		private var centerPoint:Vector3D = new Vector3D(0,0,0);
		private var camera:TargetCamera3D;
		private var contain3:ObjectContainer3D;
		private var contain2:ObjectContainer3D;
		private var contain:ObjectContainer3D;
		private var lastMouseX:Number;
		private var lastMouseY:Number;
		private var isClicked:Boolean = false;
		private var controlKey:Boolean;
		private var textfield3d:TextField3D;
		private var textfield:TextBox3D;
		private var txtFieldName:TextField;
		private var mouseLook3D:Object3DMovement = new Object3DMovement(stage,{rotX:45,rotY:90});
		private var updateTextBool:Boolean = false;
		
		
		public function Away3DFlash(){			
				stage.quality = StageQuality.HIGH;
			//scene is the root container of all 3d objects		
				
			//initialize away3d core objects
				scene = new Scene3D();	
				camera = new TargetCamera3D({x:0,y:0,z:-100});				
				camera.lookAt(centerPoint);
				
				view = new View3D({x:stage.stageWidth/2,y:stage.stageHeight/2});
				//view.x = stage.stageWidth/2;
				//view.y = stage.stageHeight/2;
				view.scene = scene;
				view.camera = camera;
				view.renderer = Renderer.BASIC;
			//view.renderer = Renderer.CORRECT_Z_ORDER;
			//add the view to the DisplayList
				addChild(view);
				initObjects();
				
		}			
			
			//initialize this movie
			private function initObjects():void{
			//create a WireCube object
				cube = new Mouth3D();
				cube.name = "aw_0";
				cube.position = new Vector3D(0,0,0);
				
				realCube = new Cube({width:10,height:10,depth:10});
				realCube.name = "realCube";
				//realCube.position = new Vector3D(0,0,0);
				trace("realCube Height: "+realCube.objectHeight+"realCube Width: "+realCube.objectWidth+" y: "+realCube.y+" maxY: "+realCube.maxY+" minY: "+realCube.minY+" maxX: "+realCube.maxX+" minX: "+realCube.minX);
			//place Mesh in containers
			//can set initial positions	
				contain = new ObjectContainer3D(cube);
				contain.position = new Vector3D(0,-10,0);
				contain.centerPivot();
				contain3 = new ObjectContainer3D();
				contain2 = new ObjectContainer3D(realCube);
			
				trace("contain2 Height: " +contain2.objectHeight+"contain2 Width: "+contain2.objectWidth+" y: "+contain2.y+" maxY: "+contain2.maxY+" minY: "+contain2.minY+" maxX: "+contain2.maxX+" minX: "+contain2.minX);
			//add the cube to the scene
				scene.addChild(contain);	
				scene.addChild(contain2);
				scene.addChild(contain3);
				
				
			//add Event listeners
				addEventListener(Event.ENTER_FRAME, onEnterFrame);
				CustomDispatcher.GetInstance().addEventListener(CustomEvent.FONT_LOADED, fontsReady);
				CustomDispatcher.GetInstance().addEventListener(CustomEvent.TEXT_READY, matchText);
				stage.addEventListener(KeyboardEvent.KEY_DOWN, enterHandler);
				stage.addEventListener(KeyboardEvent.KEY_UP, enterHandler);
				stage.addEventListener(MouseEvent.MOUSE_DOWN, stage_mouseDown);
				contain.addOnMouseDown(mouseLook3D.clickElement);
				contain3.addOnMouseDown(mouseLook3D.clickElement);	
				contain.addOnMouseDown(clickElement);
				contain2.addOnMouseDown(clickElement);
				contain3.addOnMouseDown(clickElement);
				
				
			//load the fonts
				var loadfonts:LoadFonts = new LoadFonts("assets/assets.swf")
				
			}		
			
			private function fontsReady(e:CustomEvent):void{	
				trace("fonts ready");
				make3DTextField("Helvetica");						
			}
			
			private function matchText(e:CustomEvent):void {
				updateTextBool = true;
			}
			
			private function updates():void{
				textfield3d.text = 	txtFieldName.text				
				
				textfield.getTextField3D().rotationY = contain.rotationY;
				
			}
			
			//handle enterFrame event
			private function onEnterFrame(e:Event):void{				
				view.render();
				if(updateTextBool){//updates the text from standard textfield to 3d textfield					
					updates();
				}
				
			}
						
			private function stage_mouseMove(event:MouseEvent):void {	
			//isClicked checks to see what is clicked
				if(isClicked && controlKey){
					//if(currentMeshName == "realCube"){
			//can do currentSelectedMesh.xMax - currentSelectedMesh.x Instead of 5.128
						currentSelectedMesh.x = (view.mouseX / 5.128);
						currentSelectedMesh.y = -(view.mouseY / 5.128);						
					//}	
						trace(currentSelectedMesh);
				}
				
				
				
			}
			
			private function enterHandler(event:KeyboardEvent):void
			{
				if(event.ctrlKey && event.type == "keyDown"){
					
					controlKey = true;	
					contain.removeOnMouseDown(mouseLook3D.clickElement);
					contain3.removeOnMouseDown(mouseLook3D.clickElement);	
				}else{
					controlKey = false;	
					contain3.addOnMouseDown(mouseLook3D.clickElement);	
					contain.addOnMouseDown(mouseLook3D.clickElement);
				}
				
				
			}  
			
			private function stage_mouseUp(event:MouseEvent):void {							
			//used in case the mouse up click occurs outside of object which may 
			//happen during rapid movements
				isClicked = false;				
				mouseLook3D.unClickElement(new MouseEvent3D(MouseEvent3D.MOUSE_UP));
				stage.removeEventListener(MouseEvent.MOUSE_UP, stage_mouseUp);
				stage.removeEventListener(MouseEvent.MOUSE_MOVE, stage_mouseMove);
			}			
			
			private function stage_mouseDown(event:MouseEvent):void {							
				stage.addEventListener(MouseEvent.MOUSE_UP, stage_mouseUp);
				stage.addEventListener(MouseEvent.MOUSE_MOVE, stage_mouseMove);
			}

			private function clickElement(event:MouseEvent3D):void {				
				isClicked = true;         
				currentSelectedMesh = event.object.parent;
				currentMeshName = currentSelectedMesh.name;					
			}			
			
			private function make3DTextField(fontname:String):void{
				textfield = new TextBox3D(fontname,{x:0,y:0,z:0,txtWth:stage.stageWidth,align:"left",size:30});
							
				textfield3d = textfield.getTextField3D();
				txtFieldName = textfield.getDummyTextField();				
				addChild(txtFieldName);
				contain3.addChild(textfield3d);	
				contain3.centerPivot();
				CustomDispatcher.GetInstance().dispatchEvent(new CustomEvent(CustomEvent.TEXT_READY));
				
			}			
			
			
			
			
	}//end Class
}//end Package