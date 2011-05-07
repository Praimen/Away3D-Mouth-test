package
{
	
	import away3d.materials.ColorMaterial;
	import away3d.primitives.TextField3D;	
	import away3d.core.utils.*;
	import flash.display.*;
	import flash.events.*;
	import flash.net.*;
	import flash.text.*;
	
	import wumedia.vector.*;
	
	public class TextBox3D extends TextField3D
	{
		
		private var textfield3d:TextField3D;		
		private var _ini:Init;
		private var txtFieldName:TextField;
		
		
		public function TextBox3D(font:String, init:Object=null)		{
			
			super(font, init);
		
			dummyTextField();
			
			_ini = Init.parse(init) as Init;
			
			textfield3d = new TextField3D(font);
			textfield3d.material =  new ColorMaterial(_ini.getInt("material",0xFF0000)); 		
			textfield3d.width = _ini.getNumber("width",init.txtWth);
			textfield3d.align = _ini.getString("align", "left");
			textfield3d.size = _ini.getNumber("size", 15);
			
			textfield3d.x = _ini.getNumber("x", 0);	
			textfield3d.y = _ini.getNumber("y", 0);	
			textfield3d.z = _ini.getNumber("z", 0);	
		}
		
		public function getTextField3D():TextField3D{			
			return textfield3d;
		}
		
	
		
		private function dummyTextField():void{
			txtFieldName = new TextField();			
			txtFieldName.type = "input";
			txtFieldName.text =  "mad world";								
		}
		
		
		public function getDummyTextField():TextField{			
			return txtFieldName;
		}
				
	}
}