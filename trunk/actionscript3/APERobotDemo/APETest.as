package {

   import org.cove.ape.*;
   import flash.events.Event;
   import flash.display.Sprite;

   public class APETest extends Sprite {

      public function APETest() {

         stage.frameRate = 60;
         addEventListener(Event.ENTER_FRAME, run);

         APEngine.init(1/4);
         APEngine.container = this;
         APEngine.addForce(new VectorForce(false, 0,2));

         var defaultGroup:Group = new Group();
         defaultGroup.collideInternal = true;

         var cp:CircleParticle = new CircleParticle(250,10,5);
         defaultGroup.addParticle(cp);

         var rp:RectangleParticle = new RectangleParticle(250,300,300,50,0,true);
         defaultGroup.addParticle(rp);

         APEngine.addGroup(defaultGroup);
      }

      private function run(evt:Event):void {
         APEngine.step();
         APEngine.paint();
      }
   }
}
