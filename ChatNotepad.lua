--[[ 

 @    @@        @@@      &@     @@      @@  @@@@@@&        /@#    @@      @@   @
 @    @(@      @@@@     @@ @     %@    @@   @@     @@     /@ @/    ,@*   @@    @
 @    @ *@    @@ @@    @@   @      @@#@     @@      @&   ,@   @/     @@ @.     @
 @    @. .@  @@  @@   #@%%%%%@      @@      @@      @*   @%%%%%@*     @@       @
 @    @.   @@@   @@  (@      ,@     @@      @@    @@*  .@       @.    @@       @
 
--]] -- Основное окно 1234
local ChatNotepadFrame = CreateFrame("Frame", "ChatNotepadFrame", UIParent)
ChatNotepadFrame:SetSize(400, 400)
ChatNotepadFrame:SetPoint("CENTER", 0, 0)
ChatNotepadFrame:SetMovable(true)
ChatNotepadFrame:EnableMouse(true)
ChatNotepadFrame:SetClampedToScreen(true)
ChatNotepadFrame:SetResizable(true)
ChatNotepadFrame:SetMinResize(300, 300)
ChatNotepadFrame:SetMaxResize(1366, 768)

local resizeButton = CreateFrame("Button", "ChatNotepadResizeButton", ChatNotepadFrame)
resizeButton:SetPoint("BOTTOMRIGHT", 0, 0)
resizeButton:SetSize(16, 16)
resizeButton:SetNormalTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Up")
resizeButton:SetHighlightTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Highlight")
resizeButton:SetPushedTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Down")

resizeButton:SetScript("OnMouseDown", function(self, button)
    if button == "LeftButton" then
        ChatNotepadFrame:StartSizing()
        ChatNotepadFrame:SetUserPlaced(true)
    end
end)

resizeButton:SetScript("OnMouseUp", function(self, button)
    ChatNotepadFrame:StopMovingOrSizing()
end)

local texture = ChatNotepadFrame:CreateTexture(nil, "BACKGROUND")
texture:SetTexture("Interface/DialogFrame/UI-DialogBox-Background")
texture:SetAllPoints(ChatNotepadFrame)

ChatNotepadFrame:Hide()

-- Кнопка отправить

local UploadBtn = CreateFrame("BUTTON", "UploadBtn", ChatNotepadFrame, "UIPanelButtonTemplate");

UploadBtn:SetSize(100, 25)
UploadBtn:SetText("Отправить")
UploadBtn:SetPoint("BOTTOMRIGHT", ChatNotepadFrame, -10, 10)
UploadBtn:SetFrameLevel(3)
UploadBtn:SetScript("OnClick", EditBoxSend)

-- Enter/Отправить

local function EditBoxSend()
    local TextMessage = TextField.ScrollFrame.EditBox:GetText()
    if (TextMessage == "") then
        print("|cff00488c[ChatNotepad]:|r Введите сообщение.")
        return
    end

    local selectedValue = ChatNotepadFrameDropDownMenu.selectedValue
    local dash = TextMessage:gsub("%-%-", "—")
    local quotesleft = dash:gsub("%<%<", "«")
    local quotesright = quotesleft:gsub("%>%>", "»")

    if (quotesright:sub(-1) ~= "." and quotesright:sub(-1) ~= "?" and quotesright:sub(-1) ~= "!") then
        quotesright = quotesright .. "."
    end

    if (selectedValue == "SAY") then
        SendChatMessage(quotesright, selectedValue)
    elseif (selectedValue == "YELL") then
        SendChatMessage(quotesright, selectedValue)
    elseif (selectedValue == "EMOTE") then
        SendChatMessage(quotesright, selectedValue)
    elseif (selectedValue == "RAID") then
        SendChatMessage(quotesright, selectedValue)
    elseif (selectedValue == "PARTY") then
        SendChatMessage(quotesright, selectedValue)
    elseif (selectedValue == "GUILD") then
        SendChatMessage(quotesright, selectedValue)
    end
    TextField.ScrollFrame.EditBox:SetText("")
    CloseNotePad()
end

-- Название

local AddonNameTitle = ChatNotepadFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlightLarge")
AddonNameTitle:SetPoint("TOPLEFT", ChatNotepadFrame, "TOPLEFT", 10, -10)
AddonNameTitle:SetFont("Fonts\\FRIZQT__.TTF", 15, "OUTLINE")
AddonNameTitle:SetWidth(250)
AddonNameTitle:SetHeight(40)
AddonNameTitle:SetText("|cffff9716ChatNotepad|r")
AddonNameTitle:SetJustifyH("LEFT")

-- Кнопка закрытия

local ButtonClose = CreateFrame("BUTTON", "ButtonClose", ChatNotepadFrame, "SecureHandlerClickTemplate");
ButtonClose:SetNormalTexture("Interface/BUTTONS/UI-Panel-MinimizeButton-Up")
ButtonClose:SetHighlightTexture("Interface/BUTTONS/UI-Panel-MinimizeButton-Highlight")
ButtonClose:SetPushedTexture("Interface/BUTTONS/UI-Panel-MinimizeButton-Down")
ButtonClose:SetSize(32, 32)
ButtonClose:SetPoint("TOPRIGHT", ChatNotepadFrame, 0, 0)
ButtonClose:SetScript("OnClick", function(self)
    CloseNotePad()
end)
ButtonClose:SetScript("OnEnter", function(self)
    GameTooltip:SetOwner(self, "ANCHOR_LEFT")
    GameTooltip:AddLine("Закрыть")
    GameTooltip:Show()
end)
ButtonClose:SetScript("OnLeave", function(self)
    GameTooltip:Hide()
end)

-- ESC

local function EditBoxClearFocus()
    TextField.ScrollFrame.EditBox:ClearFocus()
    local selectedValue = ChatNotepadFrameDropDownMenu.selectedValue
    CloseNotePad()
end

-- Текстовое поле
local TextField = CreateFrame('Frame', 'TextField', ChatNotepadFrame)
TextField:SetPoint("TOPLEFT", AddonNameTitle, "BOTTOMLEFT", 10, 0)
TextField:SetPoint("BOTTOMRIGHT", UploadBtn, "TOPRIGHT", -10, 10)
TextField:SetPoint("TOP", AddonNameTitle, "BOTTOM", 0, -10)
TextField:EnableMouseWheel(true)

-- Фон
TextField.Background = CreateFrame('Frame', 'TextField.Background', TextField)
TextField.Background:EnableMouse(true)
TextField.Background:SetPoint("TOPLEFT", -10, 10)
TextField.Background:SetPoint("BOTTOMRIGHT", 10, -10)
TextField.Background:SetBackdrop({
    bgFile = "Interface/DialogFrame/UI-DialogBox-Background",
    edgeFile = "Interface/DialogFrame/UI-DialogBox-Border",
    edgeSize = 20,
    insets = {
        left = 5,
        right = 5,
        top = 5,
        bottom = 5
    }
})

-- Прокрутка

TextField.ScrollFrame = CreateFrame('ScrollFrame', 'TextField.ScrollFrame', TextField, 'UIPanelScrollFrameTemplate')
TextField.ScrollFrame:SetAllPoints(TextField)
TextField.ScrollFrame:EnableMouseWheel(true)

-- Редактируемый текст
TextField.ScrollFrame.EditBox = CreateFrame('EditBox', 'TextField.ScrollFrame.EditBox', TextField.ScrollFrame)
TextField.ScrollFrame:SetScrollChild(TextField.ScrollFrame.EditBox) -- баг, при перемещении вниз и вверх ломает скролл
TextField.ScrollFrame.EditBox:SetMultiLine(true)
TextField.ScrollFrame.EditBox:SetAutoFocus(true)
TextField.ScrollFrame.EditBox:EnableMouse(true)
TextField.ScrollFrame.EditBox:SetFont("Fonts\\FRIZQT__.TTF", 15)
TextField.ScrollFrame.EditBox:EnableMouseWheel(true)
TextField.ScrollFrame.EditBox:SetScript("OnEscapePressed", EditBoxClearFocus)
TextField.ScrollFrame.EditBox:SetScript("OnEnterPressed", EditBoxSend)
TextField.ScrollFrame.EditBox:SetWidth(TextField:GetWidth())
TextField.ScrollFrame.EditBox:SetHeight(TextField:GetHeight())
TextField.ScrollFrame.EditBox:SetPoint('TOPLEFT', 0, 0)
TextField.ScrollFrame.EditBox:SetPoint('BOTTOMRIGHT', 0, 0)

TextField.Background:SetScript("OnMouseDown", function(self)
    TextField.ScrollFrame.EditBox:SetFocus()
end)

-- Talk

--[[ function Talk()
    local selectedValue = ChatNotepadFrameDropDownMenu.selectedValue
    if (selectedValue == "SAY") then
        SendChatMessage(".mod st 1")
    elseif (selectedValue ~= "SAY") then
        SendChatMessage(".mod st 0")
    end
end ]]

function Talk()
    if (isTalkBtn:GetChecked()) then
        SendChatMessage(".mod st 1")
    end
    --[[     else
        SendChatMessage(".mod st 0")
    end ]]
end

-- Toggler

function ToggleNotePad()
    if ChatNotepadFrame:IsShown() then
        CloseNotePad()
    else
        ChatNotepadFrame:Show()
        Talk()
    end
end

function CloseNotePad()
    ChatNotepadFrame:Hide()
    if (isTalkBtn:GetChecked()) then
        SendChatMessage(".mod st 0")
    end
end

-- Точконатор

local function isDotChecker()
    local text = TextField.ScrollFrame.EditBox:GetText()
    if (string.sub(text, -1) ~= "." or string.sub(text, -1) ~= "?" or string.sub(text, -1) ~= "!") then
        TextField.ScrollFrame.EditBox:SetText(text .. ".")
        TextField.ScrollFrame.EditBox:ClearFocus()
    end

end

-- Опция речи

local isTalkBtn = CreateFrame("CheckButton", "isTalkBtn", ChatNotepadFrame, "ChatConfigCheckButtonTemplate")
isTalkBtn:SetChecked()
isTalkBtn:SetPoint("TOPLEFT", TextField.Background, "BOTTOMLEFT")
isTalkBtn:SetHitRectInsets(5, 5, 5, 5)

local isTalkText = isTalkBtn:CreateFontString(nil, "OVERLAY", "GameFontHighlightLarge")
isTalkText:SetPoint("LEFT", isTalkBtn, "RIGHT", 0, 0)
isTalkText:SetFont("Fonts\\FRIZQT__.TTF", 15, "OUTLINE")
isTalkText:SetText("Речь")
isTalkText:SetJustifyH("LEFT")

isTalkBtn:SetScript("OnClick", function(self)
    Talk()
end)

-- Список

ChatNotepadFrameDropDownMenu = CreateFrame("Frame", "ChatNotepadFrameDropDownMenu", UploadBtn, "UIDropDownMenuTemplate")

ChatNotepadFrameDropDownMenu.items = {{
    text = "Сказать",
    value = "SAY"
}, {
    text = "Эмоция",
    value = "EMOTE"
}, {
    text = "Крик",
    value = "YELL"
}, {
    text = "Рейд",
    value = "RAID"
}, {
    text = "Группа",
    value = "PARTY"
}, {
    text = "Гильдия",
    value = "GUILD"
}}

function ChatNotepadFrameDropDownMenu_OnClick(self)
    UIDropDownMenu_SetSelectedID(ChatNotepadFrameDropDownMenu, self:GetID())
    ChatNotepadFrameDropDownMenu.selectedValue = self.value

    for i = 1, #ChatNotepadFrameDropDownMenu.items do
        local item = ChatNotepadFrameDropDownMenu.items[i]
        if item ~= self then
            item.checked = false
        end
    end
    Talk()
    ChatNotepadFrame_OnDropDownClick(self.value)
end

UIDropDownMenu_Initialize(ChatNotepadFrameDropDownMenu, function()
    for i, item in ipairs(ChatNotepadFrameDropDownMenu.items) do
        local info = UIDropDownMenu_CreateInfo()
        info.text = item.text
        info.value = item.value
        info.func = ChatNotepadFrameDropDownMenu_OnClick
        UIDropDownMenu_AddButton(info)
    end
end)

UIDropDownMenu_SetWidth(ChatNotepadFrameDropDownMenu, 100)
UIDropDownMenu_SetButtonWidth(ChatNotepadFrameDropDownMenu, 124)
UIDropDownMenu_JustifyText(ChatNotepadFrameDropDownMenu, "LEFT")
UIDropDownMenu_SetSelectedID(ChatNotepadFrameDropDownMenu, 1)
ChatNotepadFrameDropDownMenu.selectedValue = "SAY"
ChatNotepadFrameDropDownMenu:SetPoint("RIGHT", UploadBtn, "LEFT", 0, -2)

-- Мини-карта

ChatNotepadButtonFrame = CreateFrame("Frame", "ChatNotepadButtonFrame", Minimap);
ChatNotepadButtonFrame:SetMovable(true);
ChatNotepadButtonFrame:SetFrameStrata("LOW");
ChatNotepadButtonFrame:SetClampedToScreen(true);
ChatNotepadButtonFrame:SetSize(32, 32);
-- ChatNotepadButtonFrame:SetPoint("TOPLEFT", Minimap, "LEFT", 2, 0);
ChatNotepadButtonFrame:SetPoint("CENTER", Minimap, "CENTER", -40, -100);
ChatNotepadButtonFrame:EnableMouse(true);

ChatNotepadButton = CreateFrame("Button", "ChatNotepadButton", ChatNotepadButtonFrame);
ChatNotepadButton:SetMovable(true);
ChatNotepadButton:SetSize(33, 33);
ChatNotepadButton:SetPoint("TOPLEFT", ChatNotepadButtonFrame, "TOPLEFT", 0, 0);
ChatNotepadButton:SetClampedToScreen(true);

ChatNotepadButtonIcon = ChatNotepadButton:CreateTexture("$parentIcon", "BORDER");
ChatNotepadButtonIcon:SetSize(20, 20);
ChatNotepadButtonIcon:SetPoint("CENTER", -2, 1);
ChatNotepadButtonIcon:SetTexture("Interface\\Icons\\ui_chat");

ChatNotepadButtonBorder = ChatNotepadButton:CreateTexture("$parentBorder", "OVERLAY");
ChatNotepadButtonBorder:SetSize(52, 52);
ChatNotepadButtonBorder:SetPoint("TOPLEFT", 0, 0);
ChatNotepadButtonBorder:SetTexture("Interface\\Minimap\\MiniMap-TrackingBorder");

ChatNotepadButtonHighlight = ChatNotepadButton:CreateTexture(nil, "HIGHLIGHT");
ChatNotepadButtonHighlight:SetTexture("Interface\\Minimap\\UI-Minimap-ZoomButton-Highlight");
ChatNotepadButtonHighlight:SetBlendMode("ADD");
ChatNotepadButtonHighlight:SetAllPoints(ChatNotepadButton);

-- Открыть окно

ChatNotepadButton:SetScript("OnClick", function(self)
    ToggleNotePad()
end);

-- Текст кнопки

ChatNotepadButton:SetScript("OnEnter", function(self)
    GameTooltip:SetOwner(self, "ANCHOR_LEFT");
    GameTooltip:SetText("ChatNotepad");
    GameTooltip:AddLine("ЛКМ: Открыть окно ChatNotepad.", 0.9, 1, 0.5);
    GameTooltip:AddLine("ПКМ: Перетащить иконку.", 0.9, 1, 0.5);
    GameTooltip:Show();
end);
ChatNotepadButton:SetScript("OnLeave", function()
    GameTooltip:Hide();
end);

-- Двигать окно

ChatNotepadFrame:SetScript("OnMouseDown", function(self)
    self:StartMoving();
end);
ChatNotepadFrame:SetScript("OnMouseUp", function(self)
    self:StopMovingOrSizing();
end);

-- Двигать кнопку

ChatNotepadButton:SetScript("OnMouseDown", function(self, button)
    if (button == "RightButton") then
        self:StartMoving();
    end
end);
ChatNotepadButton:SetScript("OnMouseUp", function(self, button)
    if (button == "RightButton") then
        self:StopMovingOrSizing();
    end
end);
