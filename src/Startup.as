package 
{

	import com.demonsters.debugger.MonsterDebugger;
	
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;

	import flash.system.Security;
	
	import Game;
	
	import io.socket.flash.ISocketIOTransport;
	import io.socket.flash.ISocketIOTransportFactory;
	import io.socket.flash.SocketIOErrorEvent;
	import io.socket.flash.SocketIOEvent;
	import io.socket.flash.SocketIOTransportFactory;
	import io.socket.flash.XhrPollingTransport;
	
	import starling.core.Starling;
	import starling.events.EnterFrameEvent;
	
	
	[SWF(width="640", height="960", frameRate="30", backgroundColor="#FFFFFF")]
	public class Startup extends Sprite
	{		
		private var mStarling:Starling;
		
		private var _socketIOTransportFactory:ISocketIOTransportFactory = new SocketIOTransportFactory();
		private var _ioSocket:ISocketIOTransport;
		private var game:Game;
		
		public function Startup()
		{
			Security.loadPolicyFile("xmlsocket://127.0.0.1:10843");
			
			createSocket();
			MonsterDebugger.initialize(this);
			
			mStarling = new Starling(Game, stage);
			mStarling.start();
			
			//createCustomCursor(); //Create cursor
			
			// These settings are recommended to avoid problems with touch handling
			// Create a Starling instance that will run the "Game" class
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			
			mStarling.addEventListener(starling.events.Event.ROOT_CREATED, onAdded);
		}
		
		private function checkForScore(Event):void {
			if(game.getIsOver()) {
				trace("Made it to score check:" + " " + game.getScore());
				send(int(game.getScore()));
				game.removeEventListener(EnterFrameEvent.ENTER_FRAME, checkForScore);
			}
		}
		
		private function onAdded():void {
			MonsterDebugger.trace(this, "Root created");
			game = (Starling.current.root as Game);
			game.addEventListener(EnterFrameEvent.ENTER_FRAME, checkForScore);
		}
		
		private function createSocket():void {
			_ioSocket = _socketIOTransportFactory.createSocketIOTransport(XhrPollingTransport.TRANSPORT_TYPE, "192.168.1.7:8000/socket.io", this);
			_ioSocket.addEventListener(SocketIOEvent.CONNECT, onSocketConnected);
			_ioSocket.addEventListener(SocketIOEvent.DISCONNECT, onSocketDisconnected);
			_ioSocket.addEventListener(SocketIOEvent.MESSAGE, onSocketMessage);
			_ioSocket.addEventListener(SocketIOErrorEvent.CONNECTION_FAULT, onSocketConnectionFault);
			_ioSocket.addEventListener(SocketIOErrorEvent.SECURITY_FAULT, onSocketSecurityFault);
			_ioSocket.connect();
		}
		
		private function onSocketConnectionFault(event:SocketIOErrorEvent):void
		{
			MonsterDebugger.trace(this, event.type + ":" + event.text);
		}
		private function onSocketSecurityFault(event:SocketIOErrorEvent):void
		{
			MonsterDebugger.trace(this, event.type + ":" + event.text);
		}
		private function onDisconnectClick():void
		{
			_ioSocket.disconnect();
		}
		private function onSocketMessage(event:SocketIOEvent):void
		{
			if (event.message is String)
			{
				MonsterDebugger.trace(this, String(event.message));
			}
			else
			{
				MonsterDebugger.trace(this, JSON.stringify(event.message));
			}
		}
		public function send(data:Object):void
		{
			_ioSocket.send(data);
		}
		private function onSocketConnected(event:SocketIOEvent):void
		{
			MonsterDebugger.trace(this, "Connected" + event.target);
		}
		private function onSocketDisconnected(event:SocketIOEvent):void
		{
			MonsterDebugger.trace(this, "Disconnected" + event.target);
		}
	}
}
