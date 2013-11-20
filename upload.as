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
		private var listHolder:Sprite;
		private var uploadUrl:String = "http://zuffy.com/upload.php";
		private var picName:String = "null.png";

		private const BOX_WIDTH:uint = 250;
		private const BOX_HEIGHT:uint = 315;
		
		private var snaptShootWdith:Number = 250;
		private var snaptShootHeight:Number = 315;


		private var sharComplete:Function

		public function upload() {
			Security.allowDomain("*");  
			Security.allowInsecureDomain("*");
			if(stage){
				init();
			}
			else {
				addEventListener(Event.ADDED_TO_STAGE, init)
			}


			/**
 			// test
			var obj:Object = {}
			var arr = [];
			for (var i:int = 0; i< 50; i++){
				arr.push({id:i, uid:'xxx'+i, rank:'111', uid:'', name:'小样'+i, mark:'12315465'});
			}
			obj.arr = arr;
			var str:String = '<p><ul><li>123</li><li>123</li><li>12aaa3</li></ul></p>'
			
			setData(obj, str);
			*/
		}
		
		private function init(e:Event = null):void {
			if(e){
				removeEventListener(Event.ADDED_TO_STAGE, init)
			}
			var url:String = stage.loaderInfo.parameters.uploadUrl;
			uploadUrl = url || uploadUrl;
			if(ExternalInterface.available){
				// ExternalInterface.call('function(){alert("'+url+'")}');
			}
			initJS();
			initFileFilter();
			file = createFile();
			_loader = new Loader();
			_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loadHandler); 
			initUI();
			DataList.instance.setup(listHolder, 250, 315);
		}

		public function setData(dataList:Object,s:String=''):void {
			DataList.instance.setData(dataList,s);
		}

		private function initJS():void{
			if (ExternalInterface.available) {
				ExternalInterface.addCallback('setParam', setParam);
				ExternalInterface.addCallback('saveSnaptShoot', saveSnaptShoot);
			}
		}

		private function setParam(obj:Object):void {
			ExternalInterface.call('debug','in flash:'+obj.k)
			var funcName = obj.snapUploadComplete

			// 截图宽高，显示的flash宽高
			snaptShootWdith = obj.width
			snaptShootHeight = obj.height

			sharComplete = function __sharComplete(obj):void {
				ExternalInterface.call('debug','in flash: com func '+ funcName)
				ExternalInterface.call('' + funcName, obj)
			}
			uploadUrl = obj.uploadUrl
			setData(obj);
		}

		private function saveSnaptShoot():void{
			onSave();
		}

		private function initUI():void{
			currentHolder = new Sprite();
			listHolder = new Sprite();
			var t_title:Title = new Title();
			currentHolder.addChild(new BG());
			currentHolder.addChild(t_title);
			listHolder.x = 5;
			listHolder.y = t_title.height - 20;
			currentHolder.addChild(listHolder);
			addChild(currentHolder);

/*		加测试按钮
			var btnUploadFile:Sprite = new Sprite();
			btnUploadFile.graphics.beginFill(0x999999);
			btnUploadFile.graphics.drawRect(0,0,50,26);
			btnUploadFile.graphics.endFill();
			
			var btnCommit:Sprite = new Sprite();
			btnCommit.graphics.beginFill(0x999999);
			btnCommit.graphics.drawRect(0,0,50,26);
			btnCommit.graphics.endFill();
			
			btnUploadFile.x = 20;
			btnUploadFile.y = currentHolder.height;
			
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
*/
		}

		private function onSave(me:MouseEvent = null):void {
			var photoModel:PhotoModel = PhotoModel.instance()
			photoModel.photo(currentHolder, BOX_WIDTH, 375)
			photoModel.uploadPic(uploadUrl, sharComplete)
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