package dnaobject;

import Assertion.assert;
import dnaobject.DnaComponent;
import dnaobject.components.*;
import dnaobject.components.ActionMontiPlayAnimation.ActionMontiPlayAnimationComponent;
import haxe.Json;
import textparsemacro.ConfigFile;

/**
 * class DnaComponentFactory
 * this class is implementing the static factory method for creating objects from string types during runtime.
 *
 */
class DnaComponentFactory
{
	/**
	 * private ctor so nobody can creates this class
	 */
	private function new() {};

	/**
	 * create(type:DnaComponentType)
	 * this function selects the correct builder based on the type.
	 * we do this by getting the builder from our map.
	 * so any type we want to create with this function must be first registered by using the  registerBuilder function
	 * @param type
	 * @return DnaComponent
	 */
	public static function create(type:String):DnaComponent
	{
		var comp:DnaComponent = null;
		var file:Dynamic = null;

		if (type == 'PositionComponent')
		{
			comp = new PositionComponent();

			file = Json.parse(ConfigFile.text("assets/data/DnaComponentArchetypes/PositionComponent.json"));
		}
		else if (type == 'SliderComponent')
		{
			comp = new SliderComponent();
			file = Json.parse(ConfigFile.text("assets/data/DnaComponentArchetypes/SliderComponent.json"));
		}
		else if (type == 'InfiniteScrollComponent')
		{
			comp = new InfiniteScrollComponent();
			file = Json.parse(ConfigFile.text("assets/data/DnaComponentArchetypes/InfiniteScrollComponent.json"));
		}
		else if (type == 'CmdStateSwitchComponent')
		{
			comp = new CmdStateSwitchComponent();
			file = Json.parse(ConfigFile.text("assets/data/DnaComponentArchetypes/CmdStateSwitchComponent.json"));
		}
		else if (type == 'ActionFinishTaskComponent')
		{
			comp = new ActionFinishTaskComponent();
			file = Json.parse(ConfigFile.text("assets/data/DnaComponentArchetypes/ActionFinishTaskComponent.json"));
		}
		else if (type == 'ActionResetUnsavedComponent')
		{
			comp = new ActionResetUnsavedComponent();
			file = Json.parse(ConfigFile.text("assets/data/DnaComponentArchetypes/ActionResetUnsavedComponent.json"));
		}
		else if (type == 'ActionDeleteDataComponent')
		{
			comp = new ActionDeleteDataComponent();
			file = Json.parse(ConfigFile.text("assets/data/DnaComponentArchetypes/ActionDeleteDataComponent.json"));
		}
		else if (type == 'ActionMontiPlayAnimationComponent')
		{
			comp = new ActionMontiPlayAnimationComponent();
			file = Json.parse(ConfigFile.text("assets/data/DnaComponentArchetypes/ActionMontiPlayAnimation.json"));
		}
		else if (type == 'ActionUploadDataComponent')
		{
			comp = new ActionUploadDataComponent();
			file = Json.parse(ConfigFile.text("assets/data/DnaComponentArchetypes/ActionUploadDataComponent.json"));
		}
		else if (type == 'ActionDownloadDataComponent')
		{
			comp = new ActionDownloadDataComponent();
			file = Json.parse(ConfigFile.text("assets/data/DnaComponentArchetypes/ActionDownloadDataComponent.json"));
		}
		else if (type == 'ActionSetAudioVolumeComponent')
		{
			comp = new ActionSetAudioVolumeComponent();
			file = Json.parse(ConfigFile.text("assets/data/DnaComponentArchetypes/ActionSetAudioVolumeComponent.json"));
		}
		else if (type == 'ActionPlaySoundComponent')
		{
			comp = new ActionPlaySoundComponent();
			file = Json.parse(ConfigFile.text("assets/data/DnaComponentArchetypes/ActionPlaySoundComponent.json"));
		}
		else if (type == 'ActionSetLocaleComponent')
		{
			comp = new ActionSetLocaleComponent();
			file = Json.parse(ConfigFile.text("assets/data/DnaComponentArchetypes/ActionSetLocaleComponent.json"));
		}
		else if (type == 'CmdEvtTrigComponent')
		{
			comp = new CmdEvtTrigComponent();
			file = Json.parse(ConfigFile.text("assets/data/DnaComponentArchetypes/CmdEvtTrigComponent.json"));
		}
		else if (type == 'ActionShowTextComponent')
		{
			comp = new ActionShowTextComponent();
			file = Json.parse(ConfigFile.text("assets/data/DnaComponentArchetypes/ActionShowTextComponent.json"));
		}
		else if (type == 'ActionRemoveObjectComponent')
		{
			comp = new ActionRemoveObjectComponent();
			file = Json.parse(ConfigFile.text("assets/data/DnaComponentArchetypes/ActionRemoveObjectComponent.json"));
		}
		else if (type == 'ActionAddObjectComponent')
		{
			comp = new ActionAddObjectComponent();
			file = Json.parse(ConfigFile.text("assets/data/DnaComponentArchetypes/ActionAddObjectComponent.json"));
		}
		else if (type == 'ActionEnterFullscreenComponent')
		{
			comp = new ActionEnterFullscreenComponent();
			file = Json.parse(ConfigFile.text("assets/data/DnaComponentArchetypes/ActionEnterFullscreenComponent.json"));
		}
		else if (type == 'ActionAddComponentComponent')
		{
			comp = new ActionAddComponentComponent();
			file = Json.parse(ConfigFile.text("assets/data/DnaComponentArchetypes/ActionAddComponentComponent.json"));
		}
		else if (type == 'ActionUnlockComponent')
		{
			comp = new ActionUnlockComponent();
			file = Json.parse(ConfigFile.text("assets/data/DnaComponentArchetypes/ActionUnlockComponent.json"));
		}
		else if (type == 'ActionRemoveComponentComponent')
		{
			comp = new ActionRemoveComponentComponent();
			file = Json.parse(ConfigFile.text("assets/data/DnaComponentArchetypes/ActionRemoveComponentComponent.json"));
		}
		else if (type == 'ActionSetButtonStateComponent')
		{
			comp = new ActionSetButtonStateComponent();
			file = Json.parse(ConfigFile.text("assets/data/DnaComponentArchetypes/ActionSetButtonStateComponent.json"));
		}
		else if (type == 'ActionCheckNumberlineComponent')
		{
			comp = new ActionCheckNumberlineComponent();
			file = Json.parse(ConfigFile.text("assets/data/DnaComponentArchetypes/ActionCheckNumberlineComponent.json"));
		}
		else if (type == 'ActionAppearComponent')
		{
			comp = new ActionAppearComponent();
			file = Json.parse(ConfigFile.text("assets/data/DnaComponentArchetypes/ActionAppearComponent.json"));
		}
		else if (type == 'ActionHideComponent')
		{
			comp = new ActionAppearComponent();
			file = Json.parse(ConfigFile.text("assets/data/DnaComponentArchetypes/ActionAppearComponent.json"));
			cast(comp, ActionAppearComponent).invert = true;
		}
		else if (type == 'ActionDelayComponent')
		{
			comp = new ActionDelayComponent();
			file = Json.parse(ConfigFile.text("assets/data/DnaComponentArchetypes/ActionDelayComponent.json"));
		}
		else if (type == 'ActionMoveToComponent')
		{
			comp = new ActionMoveToComponent();
			file = Json.parse(ConfigFile.text("assets/data/DnaComponentArchetypes/ActionMoveToComponent.json"));
		}
		else if (type == 'ActionSetSliderPosComponent')
		{
			comp = new ActionSetSliderPosComponent();
			file = Json.parse(ConfigFile.text("assets/data/DnaComponentArchetypes/ActionSetSliderPosComponent.json"));
		}
		else if (type == 'ActionStateSwitchComponent')
		{
			comp = new ActionStateSwitchComponent();
			file = Json.parse(ConfigFile.text("assets/data/DnaComponentArchetypes/ActionStateSwitchComponent.json"));
		}
		else if (type == 'ActionFireEventComponent')
		{
			comp = new ActionFireEventComponent();
			file = Json.parse(ConfigFile.text("assets/data/DnaComponentArchetypes/ActionFireEventComponent.json"));
		}
		else if (type == 'ActionLoadTrialComponent')
		{
			comp = new ActionFireEventComponent();
			file = Json.parse(ConfigFile.text("assets/data/DnaComponentArchetypes/ActionLoadTrialComponent.json"));
		}
		else if (type == 'ActionSaveTrialComponent')
		{
			comp = new ActionFireEventComponent();
			file = Json.parse(ConfigFile.text("assets/data/DnaComponentArchetypes/ActionSaveTrialComponent.json"));
		}
		else if (type == 'ActionShrinkComponent')
		{
			comp = new ActionShrinkComponent();
			file = Json.parse(ConfigFile.text("assets/data/DnaComponentArchetypes/ActionShrinkComponent.json"));
		}
		else if (type == 'MonsterPartComponent')
		{
			comp = new MonsterPartComponent();
			file = Json.parse(ConfigFile.text("assets/data/DnaComponentArchetypes/MonsterPartComponent.json"));
		}
		else if (type == 'EventComponent')
		{
			comp = new EventComponent();
			file = Json.parse(ConfigFile.text("assets/data/DnaComponentArchetypes/EventComponent.json"));
		}
		else if (type == 'SliderTickComponent')
		{
			comp = new SliderTickComponent();
			file = Json.parse(ConfigFile.text("assets/data/DnaComponentArchetypes/SliderTickComponent.json"));
		}
		else if (type == 'NumlineZoneComponent')
		{
			comp = new NumlineZoneComponent();
			file = Json.parse(ConfigFile.text("assets/data/DnaComponentArchetypes/NumlineZoneComponent.json"));
		}

		// // AUTOMATICALLY GENERATED
		else if (type == 'UserButtonComponent')
		{
			comp = new UserButtonComponent();
			file = Json.parse(ConfigFile.text("assets/data/DnaComponentArchetypes/UserButtonComponent.json"));
		}

		// // AUTOMATICALLY GENERATED
		else if (type == 'TextBoxInputComponent')
		{
			comp = new TextBoxInputComponent();
			file = Json.parse(ConfigFile.text("assets/data/DnaComponentArchetypes/TextBoxInputComponent.json"));
		}

		// // AUTOMATICALLY GENERATED
		else if (type == 'ActionCheckArithmeticTaskComponent')
		{
			comp = new ActionCheckArithmeticTaskComponent();
			file = Json.parse(ConfigFile.text("assets/data/DnaComponentArchetypes/ActionCheckArithmeticTaskComponent.json"));
		}

		// // AUTOMATICALLY GENERATED
		else if (type == 'ActionSetTaskParamsComponent')
		{
			comp = new ActionSetTaskParamsComponent();
			file = Json.parse(ConfigFile.text("assets/data/DnaComponentArchetypes/ActionSetTaskParamsComponent.json"));
		}

		// // AUTOMATICALLY GENERATED
		else if (type == 'ActionMoveToAndPressComponent')
		{
			comp = new ActionMoveToAndPressComponent();
			file = Json.parse(ConfigFile.text("assets/data/DnaComponentArchetypes/ActionMoveToAndPressComponent.json"));
		}

		// // AUTOMATICALLY GENERATED
		else if (type == 'ActionNOPComponent')
		{
			comp = new ActionNOPComponent();
			file = Json.parse(ConfigFile.text("assets/data/DnaComponentArchetypes/ActionNOPComponent.json"));
		}

		// // AUTOMATICALLY GENERATED
		else if (type == 'ClickAreaComponent')
		{
			comp = new ClickAreaComponent();
			file = Json.parse(ConfigFile.text("assets/data/DnaComponentArchetypes/ClickAreaComponent.json"));
		}

		// // AUTOMATICALLY GENERATED
		else if (type == 'ActionCheckTaskComponent')
		{
			comp = new ActionCheckTaskComponent();
			file = Json.parse(ConfigFile.text("assets/data/DnaComponentArchetypes/ActionCheckTaskComponent.json"));
		}

		// // AUTOMATICALLY GENERATED
		else if (type == 'ActionSwitchToSubStateComponent')
		{
			comp = new ActionSwitchToSubStateComponent();
			file = Json.parse(ConfigFile.text("assets/data/DnaComponentArchetypes/ActionSwitchToSubStateComponent.json"));
		}

		// // AUTOMATICALLY GENERATED
		else if (type == 'ActionCloseSubStateComponent')
		{
			comp = new ActionCloseSubStateComponent();
			file = Json.parse(ConfigFile.text("assets/data/DnaComponentArchetypes/ActionCloseSubStateComponent.json"));
		}

		// // AUTOMATICALLY GENERATED
		else if (type == 'KeyboardInputComponent')
		{
			comp = new KeyboardInputComponent();
			file = Json.parse(ConfigFile.text("assets/data/DnaComponentArchetypes/KeyboardInputComponent.json"));
		}

		// // AUTOMATICALLY GENERATED
		else if (type == 'ActionCancelActionComponent')
		{
			comp = new ActionCancelActionComponent();
			file = Json.parse(ConfigFile.text("assets/data/DnaComponentArchetypes/ActionCancelActionComponent.json"));
		}

		// // AUTOMATICALLY GENERATED
		else if (type == 'ActionSetNextTrialBlockComponent')
		{
			comp = new ActionSetNextTrialBlockComponent();
			file = Json.parse(ConfigFile.text("assets/data/DnaComponentArchetypes/ActionSetNextTrialBlockComponent.json"));
		}

		// // AUTOMATICALLY GENERATED
		else if (type == 'ActionSaveDataComponent')
		{
			comp = new ActionSaveDataComponent();
			file = Json.parse(ConfigFile.text("assets/data/DnaComponentArchetypes/ActionSaveDataComponent.json"));
		}

		// // AUTOMATICALLY GENERATED
		else if (type == 'DisplayTimeComponent')
		{
			comp = new DisplayTimeComponent();
			file = Json.parse(ConfigFile.text("assets/data/DnaComponentArchetypes/DisplayTimeComponent.json"));
		}

		// // AUTOMATICALLY GENERATED
		else if (type == 'ButtonScaleComponent')
		{
			comp = new ButtonScaleComponent();
			file = Json.parse(ConfigFile.text("assets/data/DnaComponentArchetypes/ButtonScaleComponent.json"));
		}

		// // AUTOMATICALLY GENERATED
		else if (type == 'ActionSetText')
		{
			comp = new ActionSetText();
			file = Json.parse(ConfigFile.text("assets/data/DnaComponentArchetypes/ActionSetText.json"));
		}

		// // AUTOMATICALLY GENERATED

else if (type == 'ActionShowUnlockables')
{
	comp = new ActionShowUnlockables();
	file = Json.parse(ConfigFile.text("assets/data/DnaComponentArchetypes/ActionShowUnlockables.json"));
}

// // AUTOMATICALLY GENERATED

else if (type == 'ActionShowLevelPreview')
{
	comp = new ActionShowLevelPreview();
	file = Json.parse(ConfigFile.text("assets/data/DnaComponentArchetypes/ActionShowLevelPreview.json"));
}

// // AUTOMATICALLY GENERATED

else if (type == 'ActionSetProgress')
{
	comp = new ActionSetProgress();
	file = Json.parse(ConfigFile.text("assets/data/DnaComponentArchetypes/ActionSetProgress.json"));
}

// // AUTOMATICALLY GENERATED

else if (type == 'SymbolSlotComponent')
{
	comp = new SymbolSlotComponent();
	file = Json.parse(ConfigFile.text("assets/data/DnaComponentArchetypes/SymbolSlotComponent.json"));
}

// // AUTOMATICALLY GENERATED

else if (type == 'DragableComponent')
{
	comp = new DragableComponent();
	file = Json.parse(ConfigFile.text("assets/data/DnaComponentArchetypes/DragableComponent.json"));
}

// // AUTOMATICALLY GENERATED

else if (type == 'PatternExtendPracticeComponent')
{
	comp = new PatternExtendPracticeComponent();
	file = Json.parse(ConfigFile.text("assets/data/DnaComponentArchetypes/PatternExtendPracticeComponent.json"));
}

// // AUTOMATICALLY GENERATED

else if (type == 'ForegroundComponent')
{
	comp = new ForegroundComponent();
	file = Json.parse(ConfigFile.text("assets/data/DnaComponentArchetypes/ForegroundComponent.json"));
}

// // AUTOMATICALLY GENERATED

else if (type == 'StateMachineComponent')
{
	comp = new StateMachineComponent();
	file = Json.parse(ConfigFile.text("assets/data/DnaComponentArchetypes/StateMachineComponent.json"));
}

// // AUTOMATICALLY GENERATED

else if (type == 'DotsCtrlPracticeComponent')
{
	comp = new DotsCtrlPracticeComponent();
	file = Json.parse(ConfigFile.text("assets/data/DnaComponentArchetypes/DotsCtrlPracticeComponent.json"));
}

// // AUTOMATICALLY GENERATED

else if (type == 'DotsCtrlStatesNoTime')
{
	comp = new DotsCtrlStatesNoTime();
	file = Json.parse(ConfigFile.text("assets/data/DnaComponentArchetypes/DotsCtrlStatesNoTime.json"));
}

// // AUTOMATICALLY GENERATED

else if (type == 'DotsCtrlStatesNumeric')
{
	comp = new DotsCtrlStatesNumeric();
	file = Json.parse(ConfigFile.text("assets/data/DnaComponentArchetypes/DotsCtrlStatesNumeric.json"));
}

// // AUTOMATICALLY GENERATED

else if (type == 'DotsCtrlStatesNumericNoTime')
{
	comp = new DotsCtrlStatesNumericNoTime();
	file = Json.parse(ConfigFile.text("assets/data/DnaComponentArchetypes/DotsCtrlStatesNumericNoTime.json"));
}

// // AUTOMATICALLY GENERATED

else if (type == 'OrdCtrlStatesNoTime')
{
	comp = new OrdCtrlStatesNoTime();
	file = Json.parse(ConfigFile.text("assets/data/DnaComponentArchetypes/OrdCtrlStatesNoTime.json"));
}

// // AUTOMATICALLY GENERATED

else if (type == 'OrdCtrlPracticeComponent')
{
	comp = new OrdCtrlPracticeComponent();
	file = Json.parse(ConfigFile.text("assets/data/DnaComponentArchetypes/OrdCtrlPracticeComponent.json"));
}

// // AUTOMATICALLY GENERATED

else if (type == 'TutorialFingerComponent')
{
	comp = new TutorialFingerComponent();
	file = Json.parse(ConfigFile.text("assets/data/DnaComponentArchetypes/TutorialFingerComponent.json"));
}

// INSERT_HERE
		else
		{
			trace("type:", type);
			assert(false);
		}

		comp.fromFile(file);
		return comp;
	}
}






























































































































































































































































