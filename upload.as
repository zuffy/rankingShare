package {
	import com.zuffy.model.PhotoModel;
	
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.DataEvent;
	import flash.events.Event;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.external.ExternalInterface;
	import flash.geom.Rectangle;
	import flash.net.FileFilter;
	import flash.net.FileReference;
	import flash.system.Security;
	import flash.text.TextField;
	import com.zuffy.model.DataList;
	
	public class upload extends Sprite {
		private var _filters:Array = [];
		private var file:FileReference;
		private var _loader:Loader;
		private var currentHolder:Sprite;
		private var uploadUrl:String = "http://zuffy.com/upload.php";

		private const BOX_WIDTH:uint = 250;
		private const BOX_HEIGHT:uint = 300;


		public function upload() {
			Security.allowDomain("*");  
			Security.allowInsecureDomain("*");
			init();

			var obj:Object = {}
			var arr = [];
			for (var i:int = 0; i< 20; i++){
				arr.push({id:i, uid:'xxx'+i, rank:'111', url:'<a href="http://vip.xunlei.com"><img src="hhhttp://img.ucenter.xunlei.com/usrimg/501/50x50"></img></a><p>sadfsd</p>', des:'12315465'});
			}
			obj.arr = arr;
			setData(obj);
		}
		
		private function init():void {
			var url:String = stage.loaderInfo.parameters.uploadUrl;
			uploadUrl = url || uploadUrl;
			if(ExternalInterface.available){
				// ExternalInterface.call('function(){alert("'+url+'")}');
			}
			initFileFilter();
			file = createFile();
			_loader = new Loader();
			_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loadHandler); 
			initUI();
			DataList.instance.setup(currentHolder, BOX_WIDTH);
		}

		public function setData(dataList:Object):void {
			DataList.instance.setData(dataList);
		}
		
		private function initUI():void{
			var btnUploadFile:Sprite = new Sprite();
			btnUploadFile.graphics.beginFill(0x999999);
			btnUploadFile.graphics.drawRect(0,0,50,26);
			btnUploadFile.graphics.endFill();
			
			var btnCommit:Sprite = new Sprite();
			btnCommit.graphics.beginFill(0x999999);
			btnCommit.graphics.drawRect(0,0,50,26);
			btnCommit.graphics.endFill();
			
			btnUploadFile.x = 20;
			btnUploadFile.y = 350;
			
			btnCommit.x = btnUploadFile.x + btnUploadFile.width + 30;
			btnCommit.y = btnUploadFile.y;
			
			var txt:TextField = new TextField();
			txt.text = "上传";
			btnUploadFile.addChild(txt);
			
			
			btnCommit.buttonMode = true;

			btnUploadFile.addEventListener(MouseEvent.CLICK, onSearchFile);
			btnCommit.addEventListener(MouseEvent.CLICK, onSave)
			
			addChild(btnUploadFile);
			addChild(btnCommit);

			currentHolder = new Sprite();
			currentHolder.graphics.beginFill(0xaeaeae);
			currentHolder.graphics.drawRect(0, 0, BOX_WIDTH, BOX_HEIGHT);
			currentHolder.graphics.endFill();
			currentHolder.x = 0;
			currentHolder.y = 0;
			addChild(currentHolder);
		}

		private function onSave(me:MouseEvent):void {
			var photoModel:PhotoModel = PhotoModel.instance()
			photoModel.photo(currentHolder, BOX_WIDTH, BOX_HEIGHT)
			photoModel.uploadPic(uploadUrl)
		}
		



		// test upload
		private function onSearchFile(me:MouseEvent):void {
			file.browse(_filters)
		}
		
		private function loadHandler(e:Event):void {
			var bmp:Bitmap = (e.target.content) as Bitmap
			var w:Number = bmp.width/2
            var h:Number = bmp.height/2
			var lp:Number = this.BOX_WIDTH/this.BOX_HEIGHT
			var ip:Number =w / h
			var rect:Rectangle
			
			rect = new Rectangle(this.BOX_WIDTH - w,this.BOX_HEIGHT - h,w-this.BOX_WIDTH,h-this.BOX_HEIGHT)
			bmp.width = w
			bmp.height = h
			
			var holder:Sprite = new Sprite()
			holder.addChild(bmp)
			
			var m:Shape = new Shape()
			m.graphics.beginFill(0)
			m.graphics.drawRect(0, 0, this.BOX_WIDTH, this.BOX_HEIGHT)
			m.graphics.endFill()
			holder.mask = m

			currentHolder.addChild(m)
			currentHolder.addChild(holder)
		}

		private function initFileFilter():void {
			var filter:FileFilter
			
			filter = new FileFilter("所有支持图片文件(*.jpg,*.jpeg,*.gif,*.png)", "*.jpg;*.jpeg;*.gif;*.png")
			_filters[_filters.length] = filter

			filter = new FileFilter("JPEG files(*.jpg,*.jpeg)", "*.jpg;*.jpeg")
			_filters[_filters.length] = filter

			filter = new FileFilter("GIF files (*.gif)", "*.gif")
			_filters[_filters.length] = filter

			filter = new FileFilter("PNG files(*.png)", "*.png")
			_filters[_filters.length] = filter
		}
		
		private function createFile():FileReference {
			var _file:FileReference = new FileReference()
			_file.addEventListener(Event.COMPLETE, fileHandler)
			_file.addEventListener(DataEvent.UPLOAD_COMPLETE_DATA, fileHandler)
			_file.addEventListener(Event.SELECT, fileHandler)
			_file.addEventListener(Event.OPEN, fileHandler)
			_file.addEventListener(ProgressEvent.PROGRESS, fileHandler)
			_file.addEventListener(SecurityErrorEvent.SECURITY_ERROR, fileHandler)
			_file.addEventListener(IOErrorEvent.IO_ERROR, fileHandler)
			_file.addEventListener(HTTPStatusEvent.HTTP_STATUS, fileHandler)
			return _file
		}
		
		private function fileHandler(event:Event):void {
			var _file:FileReference
			switch(event.type) {
				case Event.COMPLETE:
					_file = event.currentTarget as FileReference
					_loader.loadBytes(_file.data)
					break
				case DataEvent.UPLOAD_COMPLETE_DATA:
					trace(event["data"])
					break
				case Event.SELECT:
					_file = event.currentTarget as FileReference
					_file.load()
					_loader.visible = false
					break
				case Event.OPEN:
					break
				case ProgressEvent.PROGRESS:
					break
				case SecurityErrorEvent.SECURITY_ERROR:
				case IOErrorEvent.IO_ERROR:
				case HTTPStatusEvent.HTTP_STATUS:
					break
			}
		}
	}
}