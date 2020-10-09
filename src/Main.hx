import js.html.KeyboardEvent;
import js.html.Event;
import js.Browser;
import rm.core.JsonEx;
import macros.FnMacros;
import rm.scenes.Scene_Title;
import js.Syntax;
import Types.HotKeyCommand;
import pixi.interaction.EventEmitter;
import core.Amaryllis;
import utils.Comment;
import utils.Fn;
import rm.Globals;

using Lambda;
using core.StringExtensions;
using core.NumberExtensions;
using StringTools;
using utils.Fn;

typedef LParams = {
  var commands: Array<HotKeyCommand>;
}

@:native('LunaHotKeyCustomizer')
@:expose('LunaHotKeyCustomizer')
class Main {
  public static var Params: LParams = null;
  public static var listener: EventEmitter = Amaryllis.createEventEmitter();

  public static function main() {
    var plugin = Globals.Plugins.filter((plugin) -> ~/<LunaHKC>/ig.match(plugin.description))[0];
    var params = plugin.parameters;
    untyped Params = {
      commands: JsonEx.parse(params['hotkeyCommands']).map((command) -> JsonEx.parse(command))
    }
    trace(Params);
    Comment.title('Setup');
    Params.commands.iter((command) -> {
      Browser.document.addEventListener('keydown', (event: KeyboardEvent) -> {
        trace('Added Event Listener for Key', event.keyCode, command.button.toUpperCase());
        if (event.keyCode == command.button.trim().toUpperCase().charCodeAt(0)) {
          Fn.eval(JsonEx.parse(command.scriptCall));
        }
      });
    });
  }

  public static function params() {
    return Params;
  }
}
