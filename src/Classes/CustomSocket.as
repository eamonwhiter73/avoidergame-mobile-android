package Classes
{
	
	import flash.errors.*;
	import flash.events.*;
	import flash.net.Socket;
	import com.demonsters.debugger.MonsterDebugger;
	
	public class CustomSocket extends Socket {
		private var response:String;
		
		public function CustomSocket(host:String = null, port:uint = 0) {
			super();
			configureListeners();
			if (host && port)  {
				super.connect(host, port);
			}
		}
		
		private function configureListeners():void {
			addEventListener(Event.CLOSE, closeHandler);
			addEventListener(Event.CONNECT, connectHandler);
			addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
			addEventListener(ProgressEvent.SOCKET_DATA, socketDataHandler);
		}
		
		private function writeln(str:String):void {
			str += "\n";
			try {
				writeUTFBytes(str);
			}
			catch(e:IOError) {
				MonsterDebugger.trace(this, e);
			}
		}
		
		private function sendRequest():void {
			MonsterDebugger.trace(this, "sendRequest");
			response = "";
			writeln("GET /");
			flush();
		}
		
		private function readResponse():void {
			var str:String = readUTFBytes(bytesAvailable);
			response += str;
		}
		
		private function closeHandler(event:Event):void {
			MonsterDebugger.trace(this, "closeHandler: " + event);
			MonsterDebugger.trace(this, response.toString());
		}
		
		private function connectHandler(event:Event):void {
			MonsterDebugger.trace(this, "connectHandler: " + event);
			sendRequest();
		}
		
		private function ioErrorHandler(event:IOErrorEvent):void {
			MonsterDebugger.trace(this, "ioErrorHandler: " + event);
		}
		
		private function securityErrorHandler(event:SecurityErrorEvent):void {
			MonsterDebugger.trace(this, "securityErrorHandler: " + event);
		}
		
		private function socketDataHandler(event:ProgressEvent):void {
			MonsterDebugger.trace(this, "socketDataHandler: " + event);
			readResponse();
		}
	}
}