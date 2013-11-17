package com.zuffy.model {
	
	import flash.display.Sprite;
	import com.zuffy.scroll.ScrollBar;
	import flash.display.Shape;
	import flash.text.TextField;
	import flash.text.StyleSheet;
	import flash.text.TextFieldAutoSize;

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
		private var item_width:Number = 60;
		private var item_padding:Number = 20;
		private var flash_style:StyleSheet = new StyleSheet();

		public function DataList() {
			flash_sb = new ScrollBar();
			flash_item_group = new Sprite();
			flash_mask = new Sprite();
		}

		public function setData(t_lists:Object):void {
			var lists:Array = t_lists.arr
			create_item_list(lists)
		}

		public function setup(container:Sprite, t_w:Number, t_p:Number = 0):void {
			container.addChild(this)
			item_width = t_w ? t_w : item_width
			item_padding = t_p ? t_p : 20
			y = 20
		}

		private function create_item_list(lists:Array):void {
			var total:int = lists.length;
			var item_height:Number = 0;
			var item_spacing:Number = 20;
			for( var i:int = 0; i < total; i++ ) {
				var flash_item = new Sprite();
				flash_item.addChild( create_item_desc( lists[i].url ) );
				flash_item.addChildAt( create_item_bg( flash_item.height, i ), 0 );
				flash_item.y = item_height;
				item_height += flash_item.height + item_spacing;
				flash_item_group.addChild( flash_item );
			}
			flash_mask.graphics.beginFill(0xff0000);
			flash_mask.graphics.drawRect(0,0,350,200);
			flash_mask.graphics.endFill();
			addChild(flash_mask);
			addChild(flash_item_group);
			addChild(flash_sb);

			flash_sb.x = flash_item_group.x +flash_item_group.width
			flash_sb.height = flash_mask.height;
			flash_sb.scrolling(flash_item_group, flash_mask, 0.40);	// ScrollBar Added
		}


		private function create_item_bg( h:Number, item_no:Number ):Shape {
			var fm_rect:Shape = new Shape()
			fm_rect.graphics.beginFill(0xF2F2F2, 0.5)	// ITEM BACKGROUND COLOR
			trace(item_width, h + item_padding * 2)
			fm_rect.graphics.drawRoundRect(0, 0, item_width, h + item_padding * 2, 3)
			fm_rect.graphics.endFill()
			return fm_rect
		}

		private function create_item_desc( item_desc:String ):TextField {
			var fm_text:TextField = new TextField();
			fm_text.x = item_padding;
			fm_text.y = 0;
			fm_text.width = item_width - item_padding*2;
			fm_text.styleSheet = flash_style;
			fm_text.htmlText = item_desc;
			fm_text.multiline = true;
			fm_text.wordWrap = true;
			fm_text.border = true;
			fm_text.selectable = false;
			fm_text.autoSize = TextFieldAutoSize.LEFT;
			return fm_text;
		}

	}
}