﻿package {
	import com.zuffy.model.PhotoModel;
	
	import flash.display.Bitmap;
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
	import flash.display.StageScaleMode;
	import flash.display.StageAlign;
	
	public class upload extends Sprite {
		private var _filters:Array = [];
		private var file:FileReference;
		private var currentHolder:Sprite;
		private var currentHolderMask:Sprite;
		private var listHolder:Sprite;
		private var uploadUrl:String = "";
		private var picName:String = "null.png";

		private const BOX_WIDTH:uint = 250;
		private const BOX_HEIGHT:uint = 315;
		
		private var snaptShootWdith:Number = 250;
		private var snaptShootHeight:Number = 315;
		private var logFunc:String;
		private var showMoreFunc:String;

		private var sharComplete:Function
		private var bg:BG = new BG()
		public function upload() {
			Security.allowDomain("*");  
			Security.allowInsecureDomain("*");
			if(stage){
				init();
			}
			else {
				addEventListener(Event.ADDED_TO_STAGE, init)
			}
		}
		
		private function init(e:Event = null):void {
			if(e){
				removeEventListener(Event.ADDED_TO_STAGE, init)
			}
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			
			
			addEventListener(Event.ENTER_FRAME, checkJS)
			initUI();
		}

		private function initJS():void{
			ExternalInterface.addCallback('setParam', setParam);
			ExternalInterface.addCallback('setList', setList);
			ExternalInterface.addCallback('saveSnaptShoot', saveSnaptShoot);
		}

		private var times:int = 0;
		private function checkJS(e:Event):void {
			if (ExternalInterface.available) {
				initJS();
				removeEventListener(Event.ENTER_FRAME, checkJS);
			}
			times++;
		}

		
		private var isSetup:Boolean = false;
		private function setParam(obj:Object):void {
			
			var funcName = obj.snapUploadComplete // 截图上传完毕

			// 截图宽高，显示的flash宽高
			snaptShootWdith = obj.width || snaptShootWdith
			snaptShootHeight = obj.height || snaptShootHeight

			logFunc = obj.logFunc // 日志输出函数
			showMoreFunc = obj.showMoreFunc	// 显示更多按钮点击的回调函数
			uploadUrl = obj.uploadUrl // 上传路径
			if(obj.bg2){
				bg.gotoAndStop(2)
			}
			debug('in flash:'+obj.k)

			sharComplete = function __sharComplete(obj):void {
				debug('in flash: com func '+ funcName)
				ExternalInterface.call('' + funcName, obj)
			}
			
			if(!isSetup) {
				var dh:Number = snaptShootHeight - listHolder.y;
				DataList.instance.setup(listHolder, showMoreFunc, snaptShootWdith, dh);
				isSetup = true;
			}

			currentHolderMask.graphics.beginFill(0xff0000);
			currentHolderMask.graphics.drawRect(0,0,snaptShootWdith,snaptShootHeight);
			currentHolderMask.graphics.endFill();

		}

		private function setList(lists:Array):void {
			DataList.instance.setData(lists);
		}

		private function saveSnaptShoot():void{
			onSave();
		}

		private function initUI():void{
			currentHolder = new Sprite();
			currentHolderMask = new Sprite();
			listHolder = new Sprite();
			currentHolder.addChild(bg);
			listHolder.x = 5;
			listHolder.y = 55;
			currentHolder.addChild(listHolder);
			addChild(currentHolder);
			addChild(currentHolderMask);
			currentHolder.mask = currentHolderMask
		}

		private function onSave(me:MouseEvent = null):void {
			var photoModel:PhotoModel = PhotoModel.instance()
			photoModel.photo(currentHolder, snaptShootWdith, snaptShootHeight)
			photoModel.uploadPic(uploadUrl, sharComplete)
		}

		private function debug(str:String):void {
			if(logFunc)
				ExternalInterface.call(logFunc, str)
		}

	}
}