--[[ 

 @    @@        @@@      &@     @@      @@  @@@@@@&        /@#    @@      @@   @
 @    @(@      @@@@     @@ @     %@    @@   @@     @@     /@ @/    ,@*   @@    @
 @    @ *@    @@ @@    @@   @      @@#@     @@      @&   ,@   @/     @@ @.     @
 @    @. .@  @@  @@   #@%%%%%@      @@      @@      @*   @%%%%%@*     @@       @
 @    @.   @@@   @@  (@      ,@     @@      @@    @@*  .@       @.    @@       @
 
--]] -- Окно ввода
local ChatNotepadFrame = CreateFrame("Frame", "ChatNotepadFrame", UIParent)
ChatNotepadFrame:SetSize(600, 415)
ChatNotepadFrame:SetPoint("CENTER", 0, 0)
ChatNotepadFrame:SetMovable(true)
ChatNotepadFrame:EnableMouse(true)
ChatNotepadFrame:SetClampedToScreen(true)

local texture = ChatNotepadFrame:CreateTexture(nil, "BACKGROUND")
texture:SetTexture("Interface/DialogFrame/UI-DialogBox-Background")
texture:SetAllPoints(ChatNotepadFrame)

ChatNotepadFrame:Hide()

-- Горячие клавиши

_G["BINDING_HEADER_CHATNOTEPAD"] = "ChatNotepad"
_G["BINDING_NAME_TOGGLE_CHATNOTEPAD"] = "Toggle ChatNotepad"

-- Название

local AddonNameTitle = ChatNotepadFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlightLarge")
AddonNameTitle:SetPoint("CENTER", texture, "CENTER", 0, 190)
AddonNameTitle:SetFont("Fonts\\FRIZQT__.TTF", 15, "OUTLINE")
AddonNameTitle:SetWidth(250)
AddonNameTitle:SetHeight(40)
AddonNameTitle:SetText("|cffff9716ChatNotepad|r")
AddonNameTitle:SetJustifyH("CENTER")

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
    TextField.EditBox:ClearFocus()
    local selectedValue = ChatNotepadFrameDropDownMenu.selectedValue
    CloseNotePad()
end

-- Enter/Отправить

local function EditBoxSend()
    local TextMessage = TextField.EditBox:GetText()
    if (TextMessage == "") then
        print("|cff00488c[ChatNotepad]:|r Введите сообщение.")
        return
    end

    local selectedValue = ChatNotepadFrameDropDownMenu.selectedValue
    local dash = TextMessage:gsub("%-%-", "—")
    local quotesleft = dash:gsub("%<%<", "«")
    local quotesright = quotesleft:gsub("%>%>", "»")

    if (isDotBtn:GetChecked()) then
        if (quotesright:sub(-1) ~= "." and quotesright:sub(-1) ~= "?" and quotesright:sub(-1) ~= "!") then
            quotesright = quotesright .. "."
        end
    end

    if (selectedValue == "SAY") then
        SendChatMessage(quotesright, selectedValue)
        SendChatMessage(".mod st 0")
    elseif (selectedValue == "EMOTE") then
        SendChatMessage(quotesright, selectedValue)
    elseif (selectedValue == "RAID") then
        SendChatMessage(quotesright, selectedValue)
    elseif (selectedValue == "PARTY") then
        SendChatMessage(quotesright, selectedValue)
    elseif (selectedValue == "GUILD") then
        SendChatMessage(quotesright, selectedValue)
    end
    UIErrorsFrame:AddMessage("[ChatNotepad]: Сообщение отправлено.", 1.0, 0.1, 0.1, 1.0)
    EditBoxClearFocus()
    TextField.EditBox:SetText("")
    ToggleNotePad()
end

-- Talk

--[[ function Talk()
    local talkanimation
    local TextMessage = TextField.EditBox:GetText()
    local selectedValue = ChatNotepadFrameDropDownMenu.selectedValue
    if (selectedValue == "SAY" and TextMessage ~= "") then
        SendChatMessage(".mod st 1")
        talkanimation = false
    elseif (selectedValue ~= "SAY") then
        talkanimation = true
        SendChatMessage(".mod st 0")
    end
end ]]

function Talk()
    local selectedValue = ChatNotepadFrameDropDownMenu.selectedValue
    if (selectedValue == "SAY") then
        SendChatMessage(".mod st 1")
    elseif (selectedValue ~= "SAY") then
        SendChatMessage(".mod st 0")
    end
end

-- Текстовое поле

TextField = CreateFrame('Frame', 'TextField', ChatNotepadFrame)
TextField:SetWidth(550)
TextField:SetHeight(350)
TextField:SetPoint("CENTER", ChatNotepadFrame, "CENTER", 0, 0)
TextField:EnableMouseWheel(true)

TextField.Background = CreateFrame('Frame', 'TextField', TextField)
TextField.Background:SetWidth(550)
TextField.Background:SetHeight(350)
TextField.Background:EnableMouse(true)
TextField.Background:SetPoint("CENTER", ChatNotepadFrame, "CENTER", 0, 0)
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
TextField.Background:SetMovable(true)

TextField.EditBox = CreateFrame('EditBox', 'TextField.EditBox', TextField)
TextField.EditBox:SetMultiLine(true)
TextField.EditBox:SetAutoFocus(true)
TextField.EditBox:EnableMouse(true)
TextField.EditBox:SetFont("Fonts\\FRIZQT__.TTF", 15)
TextField.EditBox:SetWidth(530)
TextField.EditBox:SetHeight(320)
TextField.EditBox:EnableMouseWheel(true)
TextField.EditBox:SetScript("OnEscapePressed", EditBoxClearFocus)
TextField.EditBox:SetScript("OnEnterPressed", EditBoxSend)
-- TextField.EditBox:SetScript("OnTextChanged", Talk)

-- Прокрутка

TextField.ScrollFrame = CreateFrame('ScrollFrame', 'TextField.ScrollFrame', TextField, 'UIPanelScrollFrameTemplate')
TextField.ScrollFrame:SetPoint('TOPLEFT', ChatNotepadFrame, 'TOPLEFT', 40, -45)
TextField.ScrollFrame:SetPoint('BOTTOMRIGHT', ChatNotepadFrame, 'BOTTOMRIGHT', -30, 45)
TextField.ScrollFrame:EnableMouseWheel(true)
TextField.ScrollFrame:SetScrollChild(TextField.EditBox)

TextField.Background:SetScript("OnMouseDown", function(self)
    TextField.EditBox:SetFocus()
end)

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
    SendChatMessage(".mod st 0")
end

-- Точконатор

local function isDotChecker()
    if (isDotBtn:GetChecked()) then
        local text = TextField.EditBox:GetText()
        if (string.sub(text, -1) ~= "." or string.sub(text, -1) ~= "?" or string.sub(text, -1) ~= "!") then
            TextField.EditBox:SetText(text .. ".")
            TextField.EditBox:ClearFocus()
        end
    end
end

-- Кнопка отправить

local UploadBtn = CreateFrame("BUTTON", "UploadBtn", ChatNotepadFrame, "UIPanelButtonTemplate");

UploadBtn:SetSize(100, 25)
UploadBtn:SetText("Отправить")
UploadBtn:SetPoint("BOTTOM", ChatNotepadFrame, 225, 5)
UploadBtn:SetFrameLevel(3)
UploadBtn:SetScript("OnClick", EditBoxSend)

-- Опция точек

local isDotBtn = CreateFrame("CheckButton", "isDotBtn", UploadBtn, "ChatConfigCheckButtonTemplate")
isDotBtn:SetPoint("TOPLEFT", -450, 0)

isDotBtn:SetScript("OnClick", function(self)
    if self:GetChecked() then
        print("|cff00488c[ChatNotepad]:|r Точки в конце поста включены.")
    else
        print("|cff00488c[ChatNotepad]:|r Точки в конце поста выключены.")
    end
end)

local isDotText = isDotBtn:CreateFontString(nil, "OVERLAY", "GameFontHighlightLarge")
isDotText:SetPoint("CENTER", UploadBtn, "CENTER", -350, 3)
isDotText:SetFont("Fonts\\FRIZQT__.TTF", 15, "OUTLINE")
isDotText:SetWidth(250)
isDotText:SetHeight(40)
isDotText:SetText("Точки в конце отписи")
isDotText:SetJustifyH("LEFT")

-- Список

ChatNotepadFrameDropDownMenu = CreateFrame("Frame", "ChatNotepadFrameDropDownMenu", UploadBtn, "UIDropDownMenuTemplate")

ChatNotepadFrameDropDownMenu.items = {{
    text = "Сказать",
    value = "SAY"
}, {
    text = "Эмоция",
    value = "EMOTE"
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
ChatNotepadFrameDropDownMenu:SetPoint("TOPLEFT", UploadBtn, "TOPLEFT", -150, 0)

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

-- Текст точконатора

isDotBtn:SetScript("OnEnter", function(self)
    GameTooltip:SetOwner(self, "ANCHOR_LEFT");
    GameTooltip:SetText("Добавит точку в конце, если вы её забыли.");
    GameTooltip:AddLine("Если она есть, то лишнюю аддон не поставит.", 0.9, 1, 0.5);
    GameTooltip:Show();
end);
isDotBtn:SetScript("OnLeave", function()
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
