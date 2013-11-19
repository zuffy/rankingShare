package com.zuffy.model {
	
	import flash.display.Sprite;
	import com.zuffy.scroll.ScrollBar;
	import flash.display.Shape;
	import flash.text.TextField;
	import flash.text.StyleSheet;
	import flash.text.TextFieldAutoSize;
	import flash.geom.Rectangle;
	import flash.events.MouseEvent;

	public class DataList extends Sprite {
		
		private static var _instance:DataList
		public static function get instance():DataList {
			if(!_instance) {
				_instance = new DataList()
			}
			return _instance
		}

		private var flash_sb:ScrollBar;
		private var flash_item_group:Sprite;
		private var flash_mask:Sprite;
		private var item_width:Number = 120;
		private var list_height:Number = 120;

		private var item_padding:Number = 20;
		private var flash_style:StyleSheet;
		private var moreIndex:int = 5;

		public function DataList() {
			flash_sb = new ScrollBar();
			flash_item_group = new Sprite();
			flash_mask = new Sprite();
			addChild(flash_mask);
			addChild(flash_item_group);
			addChild(flash_sb);
			moreIndex = 5;
			flash_sb.visible = false;
		}

		private	var lists:Array;
		public function setData(t_lists:Object, data:String=''):void {
			flash_sb.visible = true;
			lists = t_lists.arr
			create_first_list(lists)
			//create_item_list(lists)

			flash_style = new StyleSheet()
			//flash_style.setStyle('.style', { color:'#ffffff', fontSize:'15', textAlign:'center', fontFamily :'微软雅黑'})
			//flash_style.setStyle('a', {color:'#3B8FE0', fontSize:'15', textDecoration:'underline', fontFamily :'微软雅黑'})
		}

		public function setup(container:Sprite, t_w:Number=0, t_h:Number=0, t_p:Number = 0):void {
			container.addChild(this)
			item_width = t_w ? t_w : item_width
			list_height = t_h ? t_h : list_height;
			item_padding = t_p ? t_p : 20
			y = 20
		}
		private function create_content(data:String):void {
			var fm_text:TextField = new TextField();
			fm_text.x = 0;
			fm_text.y = 0;
			fm_text.width = item_width - item_padding*2;
			fm_text.styleSheet = flash_style;
			fm_text.htmlText = data;
			fm_text.multiline = true;
			fm_text.wordWrap = true;
			fm_text.border = true;
			fm_text.selectable = false;
			fm_text.autoSize = TextFieldAutoSize.LEFT;
			addChild(fm_text);
		}
		private var item_spacing:Number = 10;
		private function create_first_list(lists:Array):void {
			var total:int = lists.length;
			var item_height:Number = 0;
			var flash_item:Sprite = new Sprite();
			
			var i:int = 0, len:int = 0;
			for( i = 0; i < 5; i++ ) {
				flash_item = new Sprite();
				flash_item.addChild( create_pre_icon(i))
				flash_item.addChild( create_item_text(lists[i].name, 120) );
				flash_item.addChild( create_item_text(lists[i].mark, 65, 165) );
				//flash_item.addChildAt( create_item_bg( flash_item.height, i ), 0 );
				flash_item.y = item_height;
				item_height += flash_item.height + item_spacing;
				flash_item_group.addChild( flash_item );
			}
			var btn:More = new More();
			btn.y = item_height;
			item_height += btn.height + item_spacing;
			flash_item_group.addChild( btn );
			btn.addEventListener(MouseEvent.CLICK, function __(me:MouseEvent):void {
				create_item_list(lists)
			})
			for(len = lists.length-1, i = len - 4; i < len; i++ ) {
				flash_item = new Sprite();
				flash_item.addChild( create_pre_icon(i))
				flash_item.addChild( create_item_text(lists[i].name, 120) );
				flash_item.addChild( create_item_text(lists[i].mark, 65, 165) );
				//flash_item.addChildAt( create_item_bg( flash_item.height, i ), 0 );
				flash_item.y = item_height;
				item_height += flash_item.height + item_spacing;
				flash_item_group.addChild( flash_item );
			}

			flash_mask.graphics.beginFill(0xff0000);
			flash_mask.graphics.drawRect(0,0,item_width,list_height);
			flash_mask.graphics.endFill();
			

			flash_sb.x = flash_item_group.x +flash_item_group.width
			flash_sb.height = flash_mask.height;
			flash_sb.scrolling(flash_item_group, flash_mask, 0.90);	// ScrollBar Added
		}

		private function create_item_list(lists:Array):void {
			var total:int = lists.length;
			var item_height:Number = 0;

			while(flash_item_group.numChildren > 0) {
				flash_item_group.removeChildAt(0);
			}

			for( var i:int = 0; i < total; i++ ) {
				var flash_item = new Sprite();
				flash_item.addChild( create_pre_icon(i))
				flash_item.addChild( create_item_text(lists[i].name, 120) );
				flash_item.addChild( create_item_text(lists[i].mark, 65, 165) );
				//flash_item.addChildAt( create_item_bg( flash_item.height, i ), 0 );
				flash_item.y = item_height;
				item_height += flash_item.height + item_spacing;
				flash_item_group.addChild( flash_item );
			}
			flash_mask.graphics.beginFill(0xff0000);
			flash_mask.graphics.drawRect(0,0,item_width,list_height);
			flash_mask.graphics.endFill();
			
			flash_item_group.graphics.beginFill(0xfefefe,0);
			flash_item_group.graphics.drawRect(0,0,item_width-30,item_height);
			flash_item_group.graphics.endFill();
			
			flash_sb.x = flash_item_group.x +flash_item_group.width
			flash_sb.height = flash_mask.height;
			flash_sb.scrolling(flash_item_group, flash_mask, 0.90);	// ScrollBar Added
		}


		private function create_item_bg( h:Number, item_no:Number ):Shape {
			/*var fm_rect:Shape = new Shape()
			fm_rect.graphics.beginFill(0xF2F2F2, 0.5)	// ITEM BACKGROUND COLOR
			trace(item_width, h + item_padding * 2)
			fm_rect.graphics.drawRoundRect(0, 0, item_width, h + item_padding * 2, 3)
			fm_rect.graphics.endFill()
			return fm_rect*/return new Shape();
		}

		private function create_pre_icon(index:int):Sprite {
			var s:Sprite;
			if(index == 0) {
				s = new Rank1();
			}
			else if(index == 1) {
				s = new Rank2();
			}
			else if(index == 2) {
				s = new Rank3();
			}
			else {
				s = new Sprite();
				var bg:Shape = new Shape();
				var tx:TextField = new TextField();
				tx.text = (index + 1) +'';
				tx.textColor = 0xcfcfcf;
				//tx.background = true;
				//tx.backgroundColor = 0x0E2569;
				tx.autoSize = TextFieldAutoSize.LEFT;
				tx.selectable = false;
				s.addChild(tx)
				
				var rect:Rectangle = tx.getCharBoundaries(0);
				bg.graphics.beginFill(0x11236e);
				tx.width = (rect.width)* tx.text.length;
				tx.height = rect.height;
				bg.graphics.drawRoundRect(0,0, (rect.width)* tx.text.length + 5, rect.height, 1,1);
				bg.graphics.endFill();
				bg.y = 2.5
				s.x = 5
				s.addChildAt(bg, 0);			
			}
			return s;

		}
		private function create_item_text(item_desc:String, t_width:Number, padding_left:Number = 60, isMark:Boolean = false ):TextField {
			var fm_text:TextField = new TextField();
			fm_text.x = padding_left;
			fm_text.y = 0;
			fm_text.width = t_width;
			//fm_text.styleSheet = flash_style;
			//fm_text.htmlText = item_desc;
			fm_text.text = item_desc;
			fm_text.textColor = 0xcfcfcf
			fm_text.multiline = false;
			fm_text.wordWrap = true;
			fm_text.selectable = false;
			if(isMark)
			fm_text.autoSize = TextFieldAutoSize.RIGHT;
			else
			fm_text.autoSize = TextFieldAutoSize.LEFT;
			return fm_text;
		}

	}
}