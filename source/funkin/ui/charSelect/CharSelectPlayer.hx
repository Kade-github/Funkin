package funkin.ui.charSelect;

import flixel.FlxSprite;
import funkin.graphics.adobeanimate.FlxAtlasSprite;
import flxanimate.animate.FlxKeyFrame;
import funkin.modding.IScriptedClass.IBPMSyncedScriptedClass;
import funkin.modding.events.ScriptEvent;

class CharSelectPlayer extends FlxAtlasSprite implements IBPMSyncedScriptedClass
{
  var desLp:FlxKeyFrame = null;

  public function new(x:Float, y:Float)
  {
    super(x, y, Paths.animateAtlas("charSelect/bfChill"));

    desLp = anim.getFrameLabel("deselect loop start");

    onAnimationComplete.add(function(animLabel:String) {
      switch (animLabel)
      {
        case "slidein":
          if (hasAnimation("slidein idle point"))
          {
            playAnimation("slidein idle point", true, false, false);
          }
          else
          {
            // Handled by onBeatHit now
            playAnimation("idle", true, false, false);
          }
        case "slidein idle point":
          // Handled by onBeatHit now
          playAnimation("idle", true, false, false);
        case "idle":
          trace('Waiting for onBeatHit');
      }
    });

    onAnimationFrame.add(function(animLabel:String, frame:Int) {
      if (animLabel == "deselect" && desLp != null && frame >= desLp.index) playAnimation("deselect loop start", true, false, true);
    });
  }

  public function onStepHit(event:SongTimeScriptEvent):Void {}

  public function onBeatHit(event:SongTimeScriptEvent):Void
  {
    // TODO: There's a minor visual bug where there's a little stutter.
    // This happens because the animation is getting restarted while it's already playing.
    // I tried make this not interrupt an existing idle,
    // but isAnimationFinished() and isLoopComplete() both don't work! What the hell?
    // danceEvery isn't necessary if that gets fixed.
    if (getCurrentAnimation() == "idle")
    {
      trace('Player beat hit');
      playAnimation("idle", true, false, false);
    }
  };

  public function updatePosition(str:String)
  {
    switch (str)
    {
      case "bf":
        x = 0;
        y = 0;
      case "pico":
        x = 0;
        y = 0;
      case "random":
    }
  }

  public function switchChar(str:String)
  {
    switch str
    {
      default:
        loadAtlas(Paths.animateAtlas("charSelect/" + str + "Chill"));
    }

    playAnimation("slidein", true, false, false);

    desLp = anim.getFrameLabel("deselect loop start");

    updateHitbox();

    updatePosition(str);
  }

  public function onScriptEvent(event:ScriptEvent):Void {};

  public function onCreate(event:ScriptEvent):Void {};

  public function onDestroy(event:ScriptEvent):Void {};

  public function onUpdate(event:UpdateScriptEvent):Void {};
}
