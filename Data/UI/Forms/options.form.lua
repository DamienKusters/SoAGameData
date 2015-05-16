ButtonStyle = require "Data/UI/button_style"
SliderStyle = require "Data/UI/slider_style"
CheckBoxStyle = require "Data/UI/check_box_style"

-- Controls objects -- Is this optional????
gammaSlider = {}
gammaLabel = {}
fullscreenCheckBox = {}
borderlessCheckBox = {}

function onBackClick()
  Options.save(); -- TODO Prompt for save
  changeForm("main")
end
Vorb.register("onBackClick", onBackClick)

function onCancelClick()
  changeForm("main")
end
Vorb.register("onCancelClick", onCancelClick)

function onSaveClick()
  Options.save();
end
Vorb.register("onSaveClick", onSaveClick)

function onRestoreClick()
  Options.restoreDefault()
  setValues()
end
Vorb.register("onRestoreClick", onRestoreClick)

-- Options Changes
function onGammaChange(i)
  gamma = i / 1000.0
  Options.setFloat("Gamma", gamma)
  Label.setText(gammaLabel, "Gamma: " .. round(gamma, 2))
  Options.save()
end
Vorb.register("onGammaChange", onGammaChange)

function onFullscreenChange(b)
  Options.setBool("Fullscreen", b)
  CheckBox.setChecked(fullscreenCheckBox, b)
  Options.save()
end
Vorb.register("onFullscreenChange", onFullscreenChange)

function onBorderlessChange(b)
  Options.setBool("Borderless Window", b)
  CheckBox.setChecked(borderlessCheckBox, b)
  Options.save()
end
Vorb.register("onBorderlessChange", onBorderlessChange)

-- Rounds to a given number of decimal places
function round(num, idp)
  local mult = 10^(idp or 0)
  return math.floor(num * mult + 0.5) / mult
end

function setValues()
  -- Gamma
  gamma = Options.getFloat("Gamma")
  Slider.setValue(gammaSlider, gamma * 1000.0)
  CheckBox.setChecked(fullscreenCheckBox, Options.getBool("Fullscreen"))
  CheckBox.setChecked(borderlessCheckBox, Options.getBool("Borderless Window"))
end

function init()
  Options.beginContext();
  bw = 600 -- button width
  bh = 40 -- button height
  bx = 60 -- button X
  bsy = 700 -- start Y
  yinc = bh + 1 -- Y increment
  
  -- Bottom buttons
  saveButton = Form.makeButton(this, "saveButton", bx, bsy, bw, bh)
  ButtonStyle.set(saveButton, "Save")
  Button.addCallback(saveButton, EventType.MOUSE_CLICK, "onSaveClick")
  bsy = bsy + yinc
  
  cancelButton = Form.makeButton(this, "CancelButton", bx, bsy, bw, bh)
  ButtonStyle.set(cancelButton, "Cancel")
  Button.addCallback(cancelButton, EventType.MOUSE_CLICK, "onCancelClick")
  bsy = bsy + yinc
  
  backButton = Form.makeButton(this, "BackButton", bx, bsy, bw, bh)
  ButtonStyle.set(backButton, "Back")
  Button.addCallback(backButton, EventType.MOUSE_CLICK, "onBackClick")
  bsy = bsy + yinc
  
  restoreButton = Form.makeButton(this, "RestoreButton", bx, bsy, bw, bh)
  ButtonStyle.set(restoreButton, "Restore Defaults")
  Button.addCallback(restoreButton, EventType.MOUSE_CLICK, "onRestoreClick")
  bsy = bsy + yinc
  
  -- Test Panel
  testPanel = Form.makePanel(this, "TestPanel", 50, 50, 300, 300)
  Panel.setColor(testPanel, 128, 128, 128, 128)
  Panel.setHoverColor(testPanel, 128, 128, 128, 128)
  
  -- Gamma
  gamma = Options.getFloat("Gamma")
  gammaSlider = Form.makeSlider(this, "GammaSlider", 50, 50, 500, 15)
  Slider.setParent(gammaSlider, testPanel)
  SliderStyle.set(gammaSlider)
  Slider.setRange(gammaSlider, 100, 2500)
  Slider.addCallback(gammaSlider, EventType.VALUE_CHANGE, "onGammaChange")
  
  gammaLabel = Form.makeLabel(this, "GammaLabel", 560, 40, 300, 50)
  Label.setText(gammaLabel, "Gamma: " .. round(gamma, 2))
  Label.setTextScale(gammaLabel, 0.8, 0.8)
  Label.setTextColor(gammaLabel, 255, 255, 255, 255)
  Label.setParent(gammaLabel, testPanel)
  
  -- Borderless
  borderlessCheckBox = Form.makeCheckBox(this, "BorderlessCheckBox", 800, 50, 30, 30)
  CheckBoxStyle.set(borderlessCheckBox, "Borderless Window")
  CheckBox.addCallback(borderlessCheckBox, EventType.VALUE_CHANGE, "onBorderlessChange")
  -- Fullscreen
  fullscreenCheckBox = Form.makeCheckBox(this, "FullscreenCheckBox", 800, 90, 30, 30)
  CheckBoxStyle.set(fullscreenCheckBox, "Fullscreen")
  CheckBox.addCallback(fullscreenCheckBox, EventType.VALUE_CHANGE, "onFullscreenChange")
  
  setValues()
end

Vorb.register("init", init)