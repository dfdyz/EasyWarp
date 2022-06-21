local raw_loadfile = ...

function require(modname)
    return raw_loadfile("/lib/" .. modname .. ".lua")()
end

--init_lib
local Version = "Easy Warp 1.0.5"
--"▄"
local serialization = require("serialization")
local component = component
local computer = computer
local fs = component.proxy(computer.getBootAddress())

if fs.exists("/config") == false then
    fs.makeDirectory("/config")
end

local function write_to_file(path,strings)
    fs.remove(path)
    local handle = fs.open(path,"wb")
    fs.write(handle,strings)
    fs.close(handle)
end

local function read_file(path)
    local handle = fs.open(path,"rb")
    local str = fs.read(handle,fs.size(path))
    fs.close(handle)
    return str
end

local function tonumber_ex(a)
    if a == "" or a == "-" then
        return 0
    else
        if tonumber(a) == nil then
            return 0
        end
        return tonumber(a)
    end
end
local function get_rel_rot(state1,state2)
    local rot = {["A"] = { ["A"] = 0, ["B"] = 1, ["C"] = 2, ["D"] = 3 },
                 ["B"] = { ["A"] = 3, ["B"] = 0, ["C"] = 1, ["D"] = 2 },
                 ["C"] = { ["A"] = 2, ["B"] = 3, ["C"] = 0, ["D"] = 1 },
                 ["D"] = { ["A"] = 1, ["B"] = 2, ["C"] = 3, ["D"] = 0 } }
    return rot[state1][state2]
end

local function get_local_rot(x,z)
    if x == 0 and z == 1 then
        return "C"
    elseif x == 1 and z == 0 then
        return "B"
    elseif x == 0 and z == -1 then
        return "A"
    elseif x == -1 and z == 0 then
        return "D"
    end
end

local gpu = component.proxy(component.list("gpu",true)())
local Ship = component.proxy(component.list("warpdriveShipCore",true)())
local Screen = component.proxy(component.list("screen")())

local char_number_only = "0123456789.-"

gpu.setViewport(80,25)
gpu.setResolution(80,25)

function component_reload()
    Screen = component.proxy(component.list("screen")())

    while true do
        if not Screen then
            Screen = component.proxy(component.list("screen")())
            sleep(0.5)
        else
            gpu = component.proxy(component.list("gpu",true)())
            Ship = component.proxy(component.list("warpdriveShipCore",true)())
            fs = component.proxy(computer.getBootAddress())
            break
        end
    end

    if not gpu.getScreen() then
        gpu.bind(Screen.address)
        gpu.setViewport(80,25)
        gpu.setResolution(80,25)
        return true
    end
end

component_reload()

function _G.sleep(timeout)
    checkArg(1, timeout, "number", "nil")
    local deadline = computer.uptime() + (timeout or 0)
    repeat
        computer.pullSignal(deadline - computer.uptime())
    until computer.uptime() >= deadline
end

function draw_rectangle(x,y,w,h,color)
    gpu.setBackground(color)
    gpu.fill(x,y,w,h," ")
end

function draw_LOGO(l_x,l_y)
    local logo_data = {{{0,0},{0,0},{0,0},{0,0},{0,0},{0,0},{0,0},{0,0},{0,0},{0,0},{0,0},{0,0},{0,0},{0,0},{0,0},{0,0},{0,0},{0,0},{0,0},{0,0},{0,0},{0,0},{0,0},{0,0},{0,0},{0,0},{0,0},{0,0},{0,0},{0,0},{0,0},{0,0},{0,0},{0,0},{0,0},{0,0},{0,0},{0,0},{0,0},{0,0},{0,0},{0,0},{0,0},{0,0},{0,0},{0,0},{0,0},{0,0},{0,0},{0,0}},
                       {{0,0},{0,0},{0,0},{0,0},{0,0},{0,0},{0,0},{0,0},{0,0},{0,0},{0,0},{0,0},{0,0},{0,0},{0,0},{0,0},{0,0},{0,0},{0,0},{0,0},{0,0},{0,0},{0,0},{0,0},{0,0},{0,0},{0,0},{0,0},{0,0},{0,1},{0,1},{1,1},{1,1},{1,1},{1,1},{1,1},{1,1},{0,1},{0,1},{0,0},{0,0},{0,0},{0,0},{0,0},{0,0},{0,0},{0,0},{0,0},{0,0},{0,0}},
                       {{0,0},{0,0},{0,0},{0,0},{0,0},{0,1},{0,1},{0,1},{0,1},{0,1},{0,1},{0,1},{0,1},{0,1},{0,1},{0,1},{0,1},{0,1},{0,1},{0,1},{0,1},{0,1},{0,1},{0,1},{0,0},{0,0},{0,0},{0,1},{1,1},{1,1},{1,1},{1,1},{1,1},{1,1},{1,1},{1,1},{1,1},{1,1},{1,1},{1,1},{0,1},{0,0},{0,0},{0,0},{0,0},{0,0},{0,0},{0,0},{0,0},{0,0}},
                       {{0,0},{0,0},{0,0},{0,0},{0,0},{1,1},{1,1},{1,1},{1,1},{1,1},{1,1},{1,1},{1,1},{1,1},{1,1},{1,1},{1,1},{1,1},{1,1},{1,1},{1,1},{1,1},{1,1},{1,1},{0,0},{0,1},{1,1},{1,1},{1,1},{1,1},{1,1},{1,1},{1,1},{1,1},{1,1},{1,1},{1,1},{1,1},{1,1},{1,1},{1,1},{1,1},{0,1},{0,0},{0,0},{0,0},{0,0},{0,0},{0,0},{0,0}},
                       {{0,0},{0,0},{0,0},{0,0},{0,0},{0,0},{0,0},{0,0},{0,0},{0,0},{0,0},{0,0},{0,0},{0,0},{0,0},{0,0},{1,0},{1,1},{1,1},{0,1},{0,0},{0,0},{0,0},{0,0},{0,1},{1,1},{1,1},{1,1},{1,1},{1,1},{1,1},{1,1},{1,0},{0,0},{0,0},{1,0},{1,1},{1,1},{1,1},{1,1},{1,1},{1,1},{1,1},{0,1},{0,0},{0,0},{0,0},{0,0},{0,0},{0,0}},
                       {{0,0},{0,0},{0,0},{0,0},{0,0},{0,0},{0,0},{0,0},{0,0},{0,0},{0,0},{0,0},{0,0},{0,0},{0,0},{1,1},{1,1},{1,1},{1,1},{1,1},{1,1},{1,1},{1,1},{1,1},{1,1},{1,1},{1,1},{1,1},{1,1},{1,1},{1,0},{0,0},{0,1},{1,1},{1,1},{0,1},{0,0},{1,0},{1,1},{1,1},{1,1},{1,1},{1,1},{1,1},{0,0},{0,0},{0,0},{0,0},{0,0},{0,0}},
                       {{0,0},{0,0},{0,0},{0,0},{0,0},{0,0},{0,0},{0,0},{0,0},{0,0},{0,0},{0,0},{0,0},{0,0},{0,0},{1,1},{1,1},{1,1},{1,1},{1,1},{1,1},{1,1},{1,1},{1,1},{1,1},{1,1},{1,1},{1,1},{1,1},{1,1},{0,1},{0,0},{1,0},{1,1},{1,1},{1,0},{0,0},{0,1},{1,1},{1,1},{1,1},{1,1},{1,1},{1,1},{0,0},{0,0},{0,0},{0,0},{0,0},{0,0}},
                       {{0,0},{0,0},{0,0},{0,0},{0,0},{0,0},{0,0},{0,0},{0,0},{0,0},{0,0},{0,0},{0,0},{0,0},{0,0},{0,0},{0,1},{1,1},{1,1},{1,0},{0,0},{0,0},{0,0},{0,0},{1,0},{1,1},{1,1},{1,1},{1,1},{1,1},{1,1},{1,1},{0,1},{0,0},{0,0},{0,1},{1,1},{1,1},{1,1},{1,1},{1,1},{1,1},{1,1},{1,0},{0,0},{0,0},{0,0},{0,0},{0,0},{0,0}},
                       {{0,0},{0,0},{0,0},{0,0},{0,0},{1,1},{1,1},{1,1},{1,1},{1,1},{1,1},{1,1},{1,1},{1,1},{1,1},{1,1},{1,1},{1,1},{1,1},{1,1},{1,1},{1,1},{1,1},{1,1},{0,0},{1,0},{1,1},{1,1},{1,1},{1,1},{1,1},{1,1},{1,1},{1,1},{1,1},{1,1},{1,1},{1,1},{1,1},{1,1},{1,1},{1,1},{1,0},{0,0},{0,0},{0,0},{0,0},{0,0},{0,0},{0,0}},
                       {{0,0},{0,0},{0,0},{0,0},{0,0},{1,0},{1,0},{1,0},{1,0},{1,0},{1,0},{1,0},{1,0},{1,0},{1,0},{1,0},{1,0},{1,0},{1,0},{1,0},{1,0},{1,0},{1,0},{1,0},{0,0},{0,0},{0,0},{1,0},{1,1},{1,1},{1,1},{1,1},{1,1},{1,1},{1,1},{1,1},{1,1},{1,1},{1,1},{1,1},{1,0},{0,0},{0,0},{0,0},{0,0},{0,0},{0,0},{0,0},{0,0},{0,0}},
                       {{0,0},{0,0},{0,0},{0,0},{0,0},{0,0},{0,0},{0,0},{0,0},{0,0},{0,0},{0,0},{0,0},{0,0},{0,0},{0,0},{0,0},{0,0},{0,0},{0,0},{0,0},{0,0},{0,0},{0,0},{0,0},{0,0},{0,0},{0,0},{0,0},{1,0},{1,0},{1,1},{1,1},{1,1},{1,1},{1,1},{1,1},{1,0},{1,0},{0,0},{0,0},{0,0},{0,0},{0,0},{0,0},{0,0},{0,0},{0,0},{0,0},{0,0}},
                       {{0,0},{0,0},{0,0},{0,0},{0,0},{0,0},{0,0},{0,0},{0,0},{0,0},{0,0},{0,0},{0,0},{0,0},{0,0},{0,0},{0,0},{0,0},{0,0},{0,0},{0,0},{0,0},{0,0},{0,0},{0,0},{0,0},{0,0},{0,0},{0,0},{0,0},{0,0},{0,0},{0,0},{0,0},{0,0},{0,0},{0,0},{0,0},{0,0},{0,0},{0,0},{0,0},{0,0},{0,0},{0,0},{0,0},{0,0},{0,0},{0,0},{0,0}}}

    local Bg_color = 0xDDDDDD
    local Fg_color = 0xFFFFFF
    for y,a in ipairs(logo_data) do
        for x,b in ipairs(a) do
            if b[1]==0 then
                gpu.setBackground(Bg_color)
            else
                gpu.setBackground(Fg_color)
            end
            if b[2]==0 then
                gpu.setForeground(Bg_color)
            else
                gpu.setForeground(Fg_color)
            end
            gpu.set(l_x+x-1,l_y+y-1,"▄")
        end
    end
end

function draw_title(x,y,w,txt,color,txtcolor)
    gpu.setBackground(color)
    gpu.setForeground(txtcolor)
    gpu.fill(x,y,w,1," ")
    gpu.set(math.floor((w - string.len(txt)) / 2),y,txt)
end
function draw_txt(x,y,txt,color,txtcolor)
    gpu.setBackground(color)
    gpu.setForeground(txtcolor)
    gpu.set(x,y,txt)
end
--class Button
function CreateButton(x,y,w,h,color,txtcolor,txt,id)
    local this = {}
    this.x,this.y,this.w,this.h,this.color,this.txtcolor,this.txt,this.id,this.type = x,y,w,h,color,txtcolor,txt,id,"Button"
    this.function_on_click = function() end
    return this
end
function Button_draw(input_Button)
    draw_rectangle(input_Button.x,input_Button.y,input_Button.w,input_Button.h,input_Button.color)
    gpu.setForeground(input_Button.txtcolor)
    gpu.set(input_Button.x + math.floor((input_Button.w - string.len(input_Button.txt)) / 2), input_Button.y + math.floor(input_Button.h/2), input_Button.txt)
end
function Button_draw_ALL(Button_list)
    for k,v in ipairs(Button_list) do
        Button_draw(v)
    end
end
--class Button end

--class edit box
function Create_Edit_Box(x,y,w,normal_color,hot_color,txtcolor,id,valid_char)
    local this = {}
    this.x,this.y,this.w,this.normal_color,this.hot_color,this.txtcolor,this.id = x,y,w,normal_color,hot_color,txtcolor,id
    this.txt,this.h,this.type = "",1,"Edit_box"
    if valid_char == nil then
        this.valid_char =  "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz1234567890+-*/.,<>?;:'\"|\\][{}_=`~!@#$%^&*()"
    else
        this.valid_char = valid_char
    end
    this.function_on_click = function() end
    this.function_txt_change = function() end
    return this
end

function Is_valid_char(charin,all_char)
    if string.find(all_char,charin) ~= nil then
        return true
    else
        return false
    end
end

function Edit_Box_draw(Edit_Box,hot)
    if hot then
        draw_rectangle(Edit_Box.x,Edit_Box.y,Edit_Box.w,1,Edit_Box.hot_color)
    else
        draw_rectangle(Edit_Box.x,Edit_Box.y,Edit_Box.w,1,Edit_Box.normal_color)
    end
    gpu.setForeground(Edit_Box.txtcolor)

    if string.len(Edit_Box.txt) > Edit_Box.w then
        gpu.set(Edit_Box.x, Edit_Box.y, string.sub(Edit_Box.txt,string.len(Edit_Box.txt)-Edit_Box.w+1))
    else
        gpu.set(Edit_Box.x, Edit_Box.y, Edit_Box.txt)
    end
end

function Edit_Box_draw_ALL(Edit_Box_list,hot_id)
    for _,v in ipairs(Edit_Box_list) do
        if v.id == hot_id then
            Edit_Box_draw(v,true)
        else
            Edit_Box_draw(v,false)
        end
    end
end
function Edit_Box_Backspace(Edit_Box_list,Edit_Box_id)
    for _,v in ipairs(Edit_Box_list) do
        if v.id == Edit_Box_id then
            v.txt = string.sub(v.txt,0,string.len(v.txt) - 1)
            Edit_Box_draw(v,true)
            v.function_txt_change()
            return
        end
    end
end

--class edit box end

--class rot box
function Create_rot_box(x,y,bg_color,hot_color,cold_color,mid_color,id)
    local this = {}
    this.x,this.y,this.bg_color,this.hot_color,this.cold_color,this.mid_color,this.id,this.type = x,y,bg_color,hot_color,cold_color,mid_color,id,"Rot_box"
    this.w,this.h = 14,7
    this.hot_side = "A"
    return this
end

function draw_txt_from_Rot_Box(Rot_box,txt_color)
    draw_txt(Rot_box.x+6,Rot_box.y,"-Z",Rot_box.cold_color,txt_color)
    draw_txt(Rot_box.x+6,Rot_box.y+6,"+Z",Rot_box.cold_color,txt_color)
    draw_txt(Rot_box.x,Rot_box.y+3,"-X",Rot_box.cold_color,txt_color)
    draw_txt(Rot_box.x+12,Rot_box.y+3,"+X",Rot_box.cold_color,txt_color)
    if Rot_box.hot_side == "A" then
        draw_txt(Rot_box.x+6,Rot_box.y,"-Z",Rot_box.hot_color,txt_color)
    elseif Rot_box.hot_side == "B" then
        draw_txt(Rot_box.x+12,Rot_box.y+3,"+X",Rot_box.hot_color,txt_color)
    elseif Rot_box.hot_side == "C" then
        draw_txt(Rot_box.x+6,Rot_box.y+6,"+Z",Rot_box.hot_color,txt_color)
    elseif Rot_box.hot_side == "D" then
        draw_txt(Rot_box.x,Rot_box.y+3,"-X",Rot_box.hot_color,txt_color)
    end

end

function draw_Rot_Box(Rot_box)
    draw_rectangle(Rot_box.x,Rot_box.y,14,7,Rot_box.bg_color)
    draw_rectangle(Rot_box.x+6,Rot_box.y,2,7,Rot_box.cold_color)
    draw_rectangle(Rot_box.x,Rot_box.y+3,14,1,Rot_box.cold_color)
    draw_rectangle(Rot_box.x+6,Rot_box.y+3,2,1,Rot_box.mid_color)
    if Rot_box.hot_side == "A" then
        draw_rectangle(Rot_box.x+6,Rot_box.y,2,3,Rot_box.hot_color)
    elseif Rot_box.hot_side == "B" then
        draw_rectangle(Rot_box.x+8,Rot_box.y+3,6,1,Rot_box.hot_color)
    elseif Rot_box.hot_side == "C" then
        draw_rectangle(Rot_box.x+6,Rot_box.y+4,2,3,Rot_box.hot_color)
    elseif Rot_box.hot_side == "D" then
        draw_rectangle(Rot_box.x,Rot_box.y+3,6,1,Rot_box.hot_color)
    end
end

function Rot_box_get_click(x,y,rot_box)
    if x>=rot_box.x+6 and x<=rot_box.x+7 and y>=rot_box.y and y<=rot_box.y+2 then
        return "A"
    elseif x>=rot_box.x+8 and x<=rot_box.x+13 and y==rot_box.y+3 then
        return "B"
    elseif x>=rot_box.x+6 and x<=rot_box.x+7 and y>=rot_box.y+4 and y<=rot_box.y+6 then
        return "C"
    elseif x>=rot_box.x and x<=rot_box.x+5 and y==rot_box.y+3 then
        return "D"
    end
    return rot_box.hot_side
end
--class rot end

--class list box
function Create_List_box(x,y,w,h,bg_color,hot_color,txt_color,id)
    local this = {}
    this.x,this.y,this.w,this.h,this.bg_color,this.hot_color,this.txt_color,this.id,this.type = x,y,w,h,bg_color,hot_color,txt_color,id,"List_box"
    this.hot,this.page_now,this.table = 1,1,{}
    return this
end
function List_box_get_click_abs(List_box,y)
    local l_a,max_a = List_box_get_click_rel(List_box,y),Table_get_num(List_box.table)
    local abs_a = (List_box.page_now - 1) * List_box.h + l_a
    if abs_a > max_a then
        return max_a
    else
        return abs_a
    end
end
function List_box_get_click_rel(List_box,y)
    return (y - List_box.y + 1)
end
function List_box_goto_page(L_B,p)
    local max = List_box_get_max_page(L_B)
    if p > max then
        L_B.page_now = max
    elseif p <= 0  then
        L_B.page_now = 1
    else
        L_B.page_now = p
    end
end
function List_box_get_max_page(L_B)
    return (math.floor(Table_get_num(L_B.table) / L_B.h)+1)
end
function Table_get_num(TABLE)
    local i = 0
    for _,_ in ipairs(TABLE) do i = i + 1 end
    return i
end
function draw_List_box(L_B,is_num)
    draw_rectangle(L_B.x,L_B.y,L_B.w,L_B.h,L_B.bg_color)
    local i = 0
    local l_k_i = L_B.y * (L_B.page_now - 1)
    while Table_get_num(L_B.table) ~= 0 do
        i = i + 1
        if i == L_B.hot then
            draw_rectangle(L_B.x, L_B.y + i - 1,L_B.w,1,L_B.hot_color)
            if is_num == true then
                list_box_draw_txt(L_B.x, L_B.y + i - 1, tostring(i + l_k_i).."  "..tostring(L_B.table[i + l_k_i]), L_B.hot_color, L_B.txt_color,L_B.w)
            else
                list_box_draw_txt(L_B.x, L_B.y + i - 1, tostring(L_B.table[i + l_k_i]), L_B.hot_color, L_B.txt_color,L_B.w)
            end
        else
            if is_num == true then
                list_box_draw_txt(L_B.x, L_B.y + i - 1, tostring(i + l_k_i).."  "..tostring(L_B.table[i + l_k_i]), L_B.bg_color, L_B.txt_color,L_B.w)
            else
                list_box_draw_txt(L_B.x, L_B.y + i - 1, tostring(L_B.table[i + l_k_i]), L_B.bg_color, L_B.txt_color,L_B.w)
            end
        end
        if i >= Table_get_num(L_B.table) or i >= L_B.h then
            break
        end
    end
end
function list_box_draw_txt(x,y,txt,bg_color,txt_color,max_len)
    local a = txt
    if string.len(txt) > max_len then
        a = string.sub(txt,1,max_len)
    end
    draw_txt(x,y,a,bg_color,txt_color)
end
--class list box end

function Is_Button_click(x,y,Button_list)
    for i,v in ipairs(Button_list) do
        if(x >= v.x and x < v.x+v.w and y >= v.y and y < v.y+v.h)
        then
            return v.type,v.id
        end
    end
    return nil
end

function Edit_Box_editing(Edit_Box_list,Edit_Box_id,add_string)
    for _,v in ipairs(Edit_Box_list) do
        if v.id == Edit_Box_id then
            if Is_valid_char(add_string,v.valid_char) == true then
                v.txt = v.txt..add_string
                Edit_Box_draw(v,true)
                v.function_txt_change()
            end
        end
    end
end

function GUI_init_G()
    Page_jump_Target_Rot_Box = Create_rot_box(3,12,0xFFFFFF,0xFFFF33,0xCCDDFF,0x00FF00,"RT")
    local l_x,_,l_y = Ship.getOrientation()
    Page_jump_Target_Rot_Box.hot_side = get_local_rot(l_x,l_y)

    GloBal_Offset_list_box = Create_List_box(36,6,20,13,0xFFFFFF,0x00FFFF,0x000000,"G_L_B")
    GloBal_Offset_list_box.table = { "Core" }
end

function Page_Config()
    local Page_Config_Back_Button = CreateButton(1,23,10,3,0xFFFFFF,0x000000,"Back","B1")
    local Page_Config_Shutdown_Button = CreateButton(69,23,12,3,0xFFFFFF,0x000000,"Shutdown","B2")

    local Page_Config_Button_list = {
        Page_Config_Back_Button,
        Page_Config_Shutdown_Button
    }

    draw_rectangle(1,1,80,25,0xDDDDDD)
    draw_title(1,1,80,"Easy Warp - System Config",0xAAAAAA,0xFFFFFF)
    draw_title(1,13,80,"--todo--",0xDDDDDD,0xFFFFFF)


    Button_draw_ALL(Page_Config_Button_list)

    while true do
        local Signal_Data = { computer.pullSignal(5) }
        if Signal_Data[1] == "touch" then
            local _,id = Is_Button_click(Signal_Data[3],Signal_Data[4],Page_Config_Button_list)
            if id == Page_Config_Back_Button.id then
                break
            elseif id == Page_Config_Shutdown_Button.id then
                computer.shutdown()
            end
        elseif Signal_Data[1] == nil then
            component_reload()
        end
    end
end

function DoJump(x,y,z,R)
    Ship.rotationSteps(R)
    Ship.movement(x,y,z)
    Ship.command("MANUAL", true)
end

local G_P_C = {}
local G_P_data = ""
local function flush_P()
    G_P_data = read_file("/config/Offset_Point.cfg")
    GloBal_Offset_list_box.table = nil
    GloBal_Offset_list_box.table = { "Ship_Core" }
    if not (G_P_data == nil or G_P_data == "") then
        G_P_C  = serialization.unserialize(G_P_data)
        for _,v in ipairs(G_P_C) do
            local tmp = serialization.unserialize(v)
            table.insert(GloBal_Offset_list_box.table,tmp["tag"])
        end
    end
    GloBal_Offset_list_box.hot = 1
    GloBal_Offset_list_box.page_now = 1
    draw_List_box(GloBal_Offset_list_box,false)
end

local function Rot_Plus(a,b)
    local t = {
        ["A"] = { ["A"] = "A", ["B"] = "B", ["C"] = "C", ["D"] = "D" },
        ["B"] = { ["A"] = "B", ["B"] = "C", ["C"] = "D", ["D"] = "A" },
        ["C"] = { ["A"] = "C", ["B"] = "D", ["C"] = "A", ["D"] = "B" },
        ["D"] = { ["A"] = "D", ["B"] = "A", ["C"] = "B", ["D"] = "C" }
    }
    return t[a][b]
end



local function save_P()
    write_to_file("/config/Offset_Point.cfg",serialization.serialize(G_P_C))
end

local Page_jump_cfg = ""
local G_jump_mode,G_abs_xyz,G_rel_xyz = "Relative",{ Ship.getLocalPosition() },{0,0,0}

local G_cfg = read_file("/config/last.cfg")
if not (G_cfg == nil or G_cfg == "") then
    G_cfg = serialization.unserialize(G_cfg)
    G_rel_xyz = G_cfg
end

local G_State = "World"
local ship_isInHyper = Ship.isInHyperspace()

function Page_jump()
    local hot_edit_box_id = nil

    --GUI_init
    local Page_jump_Back_Button = CreateButton(1,23,10,3,0xFFFFFF,0x000000,"Back","B1")
    local Page_jump_Engage_Button = CreateButton(69,23,12,3,0xFFFFFF,0x000000,"Engage","B2")
    local Page_jump_Mode_Absolute_Button = CreateButton(18,3,12,1,0x33FF33,0x000000,"Absolute","Absolute")
    local Page_jump_Mode_Relative_Button = CreateButton(30,3,12,1,0xFFFFFF,0x000000,"Relative","Relative")
    local Page_jump_Hyper_Button = CreateButton(57,23,12,3,0xFF0000,0x000000,"Hyper","Hyper")

    local Page_jump_list_L_Button = CreateButton(36,19,3,1,0x33FF33,0x000000,"<","BLL")
    local Page_jump_list_R_Button = CreateButton(53,19,3,1,0x33FF33,0x000000,">","BLR")
    local Page_jump_list_m_Button = CreateButton(39,19,14,1,0xDDDDDD,0x000000,"n / n","Tile")

    local Page_jump_list_Add_Button = CreateButton(74,6,3,1,0x33FF33,0x000000,"+","BL+")
    local Page_jump_list_Rm_Button = CreateButton(74,8,3,1,0x33FF33,0x000000,"-","BL-")
    local Page_jump_list_Save_Button = CreateButton(74,10,3,1,0x33FF33,0x000000,"S","BLSave")

    local Page_jump_Abs_x_Edit_box = Create_Edit_Box(7,5,22,0xFFFFFF,0x00FFFF,0x000000,"EAX",char_number_only)
    local Page_jump_Abs_y_Edit_box = Create_Edit_Box(7,7,22,0xFFFFFF,0x00FFFF,0x000000,"EAY",char_number_only)
    local Page_jump_Abs_z_Edit_box = Create_Edit_Box(7,9,22,0xFFFFFF,0x00FFFF,0x000000,"EAZ",char_number_only)

    local Page_jump_c_name_Edit_box = Create_Edit_Box(58,4,14,0xFFFFFF,0x00FFFF,0x000000,"ECNA")
    local Page_jump_c_Front_Edit_box = Create_Edit_Box(58,6,14,0xFFFFFF,0x00FFFF,0x000000,"ECX",char_number_only)
    local Page_jump_c_Right_Edit_box = Create_Edit_Box(58,8,14,0xFFFFFF,0x00FFFF,0x000000,"ECY",char_number_only)
    local Page_jump_c_Up_Edit_box = Create_Edit_Box(58,10,14,0xFFFFFF,0x00FFFF,0x000000,"ECZ",char_number_only)
    Page_jump_c_Front_Edit_box.txt = "0"
    Page_jump_c_Right_Edit_box.txt = "0"
    Page_jump_c_Up_Edit_box.txt = "0"



    local Page_jump_Local_Rot_Box = Create_rot_box(19,12,0xFFFFFF,0xFF5511,0xFFFFFF,0x00FF00,"RL")

    local Page_jump_C_Rot_Box = Create_rot_box(58,12,0xFFFFFF,0xFFFF33,0xFFFFFF,0x00FF00,"RC")
    --local Page_jump_Abs_x_Edit_box = Create_Edit_Box()

    local Page_jump_Edit_box_list_Abs = {
        Page_jump_Abs_x_Edit_box,
        Page_jump_Abs_y_Edit_box,
        Page_jump_Abs_z_Edit_box,
        Page_jump_c_name_Edit_box,
        Page_jump_c_Front_Edit_box,
        Page_jump_c_Right_Edit_box,
        Page_jump_c_Up_Edit_box
    }

    --GUI_init_end

    local function update_xyz(id)
        if G_jump_mode ~= id then
            if id == Page_jump_Mode_Relative_Button.id then
                G_abs_xyz = {
                    tonumber(Page_jump_Abs_x_Edit_box.txt),
                    tonumber(Page_jump_Abs_y_Edit_box.txt),
                    tonumber(Page_jump_Abs_z_Edit_box.txt)
                }
                Page_jump_Abs_x_Edit_box.txt = tostring(G_rel_xyz[1])
                Page_jump_Abs_y_Edit_box.txt = tostring(G_rel_xyz[2])
                Page_jump_Abs_z_Edit_box.txt = tostring(G_rel_xyz[3])
            elseif id == Page_jump_Mode_Absolute_Button.id then
                G_rel_xyz = {
                    tonumber(Page_jump_Abs_x_Edit_box.txt),
                    tonumber(Page_jump_Abs_y_Edit_box.txt),
                    tonumber(Page_jump_Abs_z_Edit_box.txt)
                }
                Page_jump_Abs_x_Edit_box.txt = tostring(G_abs_xyz[1])
                Page_jump_Abs_y_Edit_box.txt = tostring(G_abs_xyz[2])
                Page_jump_Abs_z_Edit_box.txt = tostring(G_abs_xyz[3])
            end
        end
    end

    update_xyz()

    local function update()
        update_xyz()

        Page_jump_c_name_Edit_box.txt = "Ship Core"
        Page_jump_c_Front_Edit_box.txt = "0"
        Page_jump_c_Right_Edit_box.txt = "0"
        Page_jump_c_Up_Edit_box.txt = "0"
        Page_jump_C_Rot_Box.hot_side = "A"

        Page_jump_list_m_Button.txt = tostring(GloBal_Offset_list_box.page_now).."/"..tostring(List_box_get_max_page(GloBal_Offset_list_box))

        draw_rectangle(1,1,80,25,0xDDDDDD)
        draw_title(1,1,80,"Easy Warp - Jump Sitting",0xAAAAAA,0xFFFFFF)
        Button_draw_ALL({
            Page_jump_Back_Button,
            Page_jump_Engage_Button,
            Page_jump_Hyper_Button,
            Page_jump_list_L_Button,
            Page_jump_list_R_Button,
            Page_jump_list_m_Button,
            Page_jump_list_Add_Button,
            Page_jump_list_Rm_Button,
            Page_jump_list_Save_Button
        })
        draw_txt(3,3,"Position Mode:",0xDDDDDD,0x000000)
        draw_txt(3,5,"X:",0xDDDDDD,0x000000)
        draw_txt(3,7,"Y:",0xDDDDDD,0x000000)
        draw_txt(3,9,"Z:",0xDDDDDD,0x000000)
        draw_txt(58,3,"Tag:",0xDDDDDD,0x000000)
        draw_txt(58,5,"Front:",0xDDDDDD,0x000000)
        draw_txt(58,7,"Right:",0xDDDDDD,0x000000)
        draw_txt(58,9,"Up:",0xDDDDDD,0x000000)
        draw_txt(58,11,"Rotation:",0xDDDDDD,0x000000)
        draw_txt(3,11,"Rotation",0xDDDDDD,0x000000)
        draw_txt(19,11,"Current",0xDDDDDD,0x000000)
        draw_txt(36,5,"Center offset list",0xDDDDDD,0x000000)
        ship_isInHyper = Ship.isInHyperspace()
        if ship_isInHyper then
            G_State = "Hyper"
        else
            G_State = "World"
        end
        draw_txt(3,20,"State: "..G_State,0xDDDDDD,0x000000)
        if G_jump_mode == Page_jump_Mode_Absolute_Button.id then
            Page_jump_Mode_Absolute_Button.color = 0x33FF33
            Page_jump_Mode_Relative_Button.color = 0xFFFFFF
            Page_jump_Abs_x_Edit_box.txt = tostring(G_abs_xyz[1])
            Page_jump_Abs_y_Edit_box.txt = tostring(G_abs_xyz[2])
            Page_jump_Abs_z_Edit_box.txt = tostring(G_abs_xyz[3])
            Edit_Box_draw_ALL(Page_jump_Edit_box_list_Abs,nil)
            Button_draw_ALL({Page_jump_Mode_Absolute_Button,Page_jump_Mode_Relative_Button})
        elseif G_jump_mode == Page_jump_Mode_Relative_Button.id then
            Page_jump_Mode_Relative_Button.color = 0x33FF33
            Page_jump_Mode_Absolute_Button.color = 0xFFFFFF
            Page_jump_Abs_x_Edit_box.txt = tostring(G_rel_xyz[1])
            Page_jump_Abs_y_Edit_box.txt = tostring(G_rel_xyz[2])
            Page_jump_Abs_z_Edit_box.txt = tostring(G_rel_xyz[3])
            Edit_Box_draw_ALL(Page_jump_Edit_box_list_Abs,nil)
            Button_draw_ALL({Page_jump_Mode_Absolute_Button,Page_jump_Mode_Relative_Button})
        end
        draw_Rot_Box(Page_jump_Target_Rot_Box)
        draw_txt_from_Rot_Box(Page_jump_Target_Rot_Box,0x000000)
        local l_x,_,l_y = Ship.getOrientation()
        Page_jump_Local_Rot_Box.hot_side = get_local_rot(l_x,l_y)
        draw_Rot_Box(Page_jump_Local_Rot_Box)
        draw_txt_from_Rot_Box(Page_jump_Local_Rot_Box,0x000000)
        draw_Rot_Box(Page_jump_C_Rot_Box)
        flush_P()
    end

    local function save_current_value()
        if G_jump_mode == Page_jump_Mode_Absolute_Button.id then
            G_abs_xyz = { tonumber(Page_jump_Abs_x_Edit_box.txt),
                          tonumber(Page_jump_Abs_y_Edit_box.txt),
                          tonumber(Page_jump_Abs_z_Edit_box.txt) }
        elseif G_jump_mode == Page_jump_Mode_Relative_Button.id then
            G_rel_xyz = { tonumber(Page_jump_Abs_x_Edit_box.txt),
                          tonumber(Page_jump_Abs_y_Edit_box.txt),
                          tonumber(Page_jump_Abs_z_Edit_box.txt) }
        end
    end

    local function fuck_xyz(xz)
        local l_x,_,l_y = Ship.getOrientation()
        local nmsl = get_local_rot(l_x,l_y)
        if nmsl == "A" then
            return { -xz[2], xz[1] }
        elseif nmsl == "B" then
            return { xz[1], xz[2] }
        elseif nmsl == "C" then
            return { xz[2], -xz[1] }
        elseif nmsl == "D" then
            return { -xz[1], -xz[2] }
        end
    end
    local function fuck_xz(fr, xz, Rot)
        local l_x,_,l_y = Ship.getOrientation()
        local nmsl = get_local_rot(l_x,l_y)

        local tx,tz,trx,trz,retx,retz = 0,0,0,0,0,0

        if nmsl == "A" then
            tx,tz = -fr[2],fr[1]
        elseif nmsl == "B" then
            tx,tz = -fr[1],-fr[2]
        elseif nmsl == "C" then
            tx,tz = fr[2],-fr[1]
        elseif nmsl == "D" then
            tx,tz = fr[1],fr[2]
        end

        if Rot == "A" then
            trx,trz = -fr[2],fr[1]
        elseif Rot == "B" then
            trx,trz = -fr[1],-fr[2]
        elseif Rot == "C" then
            trx,trz = fr[2],-fr[1]
        elseif Rot == "D" then
            trx,trz = fr[1],fr[2]
        end
        
        retx = trx + xz[1] - tx
        retz = trz + xz[2] - tz
        
        return {retx, retz}
    end
    local function fuck_xz_2(fr, xz, Rot)
        local l_x,_,l_y = Ship.getOrientation()
        local nmsl = get_local_rot(l_x,l_y)
        local position = { Ship.getLocalPosition() }
        local tx,tz,trx,trz,retx,retz = 0,0,0,0,0,0

        if nmsl == "A" then
            tx,tz = -fr[2],fr[1]
        elseif nmsl == "B" then
            tx,tz = -fr[1],-fr[2]
        elseif nmsl == "C" then
            tx,tz = fr[2],-fr[1]
        elseif nmsl == "D" then
            tx,tz = fr[1],fr[2]
        end

        if Rot == "A" then
            trx,trz = -fr[2],fr[1]
        elseif Rot == "B" then
            trx,trz = -fr[1],-fr[2]
        elseif Rot == "C" then
            trx,trz = fr[2],-fr[1]
        elseif Rot == "D" then
            trx,trz = fr[1],fr[2]
        end

        retx = trx + xz[1] - position[1]
        retz = trz + xz[2] - position[3]

        return {retx, retz}
    end


    update()

    local function Cheak_void()
        if Page_jump_c_Front_Edit_box.txt == "" then
            Page_jump_c_Front_Edit_box.txt = "0"
        end
        if Page_jump_c_Right_Edit_box.txt == "" then
            Page_jump_c_Right_Edit_box.txt = "0"
        end
        if Page_jump_c_Up_Edit_box.txt == "" then
            Page_jump_c_Up_Edit_box.txt = "0"
        end
        if Page_jump_c_name_Edit_box.txt == "" then
            Page_jump_c_name_Edit_box.txt = "Unnamed"
        end
    end

    while true do
        local Signal_Data = { computer.pullSignal(5) }
        if Signal_Data[1] == "touch" then
            local type,id = Is_Button_click(Signal_Data[3],Signal_Data[4],{
                Page_jump_Back_Button,
                Page_jump_Engage_Button,
                Page_jump_Mode_Absolute_Button,
                Page_jump_Mode_Relative_Button,
                Page_jump_Hyper_Button,
                Page_jump_list_L_Button,
                Page_jump_list_R_Button,
                Page_jump_list_m_Button,
                Page_jump_list_Add_Button,
                Page_jump_list_Rm_Button,
                Page_jump_list_Save_Button,
                Page_jump_Abs_x_Edit_box,
                Page_jump_Abs_y_Edit_box,
                Page_jump_Abs_z_Edit_box,
                Page_jump_c_name_Edit_box,
                Page_jump_c_Front_Edit_box,
                Page_jump_c_Right_Edit_box,
                Page_jump_c_Up_Edit_box,
                Page_jump_Target_Rot_Box,
                Page_jump_Local_Rot_Box,
                Page_jump_C_Rot_Box,
                GloBal_Offset_list_box
            })
            if type == "Button" then
                if id == Page_jump_Back_Button.id then
                    save_current_value()
                    write_to_file("/config/last.cfg",serialization.serialize(G_rel_xyz))
                    break
                elseif id == Page_jump_Engage_Button.id then
                    local l_x,_,l_y = Ship.getOrientation()
                    Page_jump_Local_Rot_Box.hot_side = get_local_rot(l_x,l_y)
                    draw_Rot_Box(Page_jump_Local_Rot_Box)
                    draw_txt_from_Rot_Box(Page_jump_Local_Rot_Box,0x000000)
                    local Rot = get_rel_rot(Page_jump_Local_Rot_Box.hot_side,Page_jump_Target_Rot_Box.hot_side)

                    save_current_value()
                    hot_edit_box_id = nil

                    local core_rot = ""
                    do
                        local l_x,_,l_y = Ship.getOrientation()
                        core_rot = get_local_rot(l_x,l_y)
                        Page_jump_Local_Rot_Box.hot_side = Rot_Plus(core_rot,Page_jump_C_Rot_Box.hot_side)
                    end

                    draw_Rot_Box(Page_jump_Local_Rot_Box)
                    draw_txt_from_Rot_Box(Page_jump_Local_Rot_Box,0x000000)

                    local n_rel_Rot = get_rel_rot(Page_jump_Local_Rot_Box.hot_side,Page_jump_Target_Rot_Box.hot_side)
                    local tran = {"A","B","C","D"}
                    local str_rel_Rot = tran[n_rel_Rot+1]
                    local relR = Rot_Plus(core_rot,str_rel_Rot)

                    --todo
                    if G_jump_mode == "Relative" then
                        local lxz = fuck_xz(
                                { tonumber_ex(Page_jump_c_Front_Edit_box.txt),
                                  tonumber_ex(Page_jump_c_Right_Edit_box.txt)},
                                {tonumber_ex(Page_jump_Abs_x_Edit_box.txt),
                                 tonumber_ex(Page_jump_Abs_z_Edit_box.txt)}, relR
                        )

                        local x_z = fuck_xyz(lxz)
                        Ship.movement(x_z[1],
                                tonumber_ex(Page_jump_Abs_y_Edit_box.txt),
                                x_z[2])

                        Ship.rotationSteps(get_rel_rot(Page_jump_Local_Rot_Box.hot_side,Page_jump_Target_Rot_Box.hot_side))

                    elseif G_jump_mode == "Absolute" then
                        local position = { Ship.getLocalPosition() }
                        local lxz = fuck_xz_2(
                                { tonumber_ex(Page_jump_c_Front_Edit_box.txt),
                                  tonumber_ex(Page_jump_c_Right_Edit_box.txt)},
                                {tonumber_ex(Page_jump_Abs_x_Edit_box.txt),
                                 tonumber_ex(Page_jump_Abs_z_Edit_box.txt)}, relR
                        )


                        local x_z = fuck_xyz(lxz)
                        Ship.movement(x_z[1],
                                tonumber_ex(Page_jump_Abs_y_Edit_box.txt) - position[2] - tonumber_ex(Page_jump_c_Up_Edit_box.txt),
                                x_z[2])

                        Ship.rotationSteps(get_rel_rot(Page_jump_Local_Rot_Box.hot_side,Page_jump_Target_Rot_Box.hot_side))

                    end
                    Ship.enable(true)
                    Ship.command("MANUAL", true)
                    Edit_Box_draw_ALL(Page_jump_Edit_box_list_Abs,nil)

                elseif id == Page_jump_Mode_Absolute_Button.id then
                    update_xyz(Page_jump_Mode_Absolute_Button.id)
                    G_jump_mode = Page_jump_Mode_Absolute_Button.id
                    Page_jump_Mode_Absolute_Button.color = 0x33FF33
                    Page_jump_Mode_Relative_Button.color = 0xFFFFFF
                    Edit_Box_draw_ALL(Page_jump_Edit_box_list_Abs,nil)
                    Button_draw_ALL({Page_jump_Mode_Absolute_Button,Page_jump_Mode_Relative_Button})
                elseif id == Page_jump_Mode_Relative_Button.id then
                    update_xyz(Page_jump_Mode_Relative_Button.id)
                    G_jump_mode = Page_jump_Mode_Relative_Button.id
                    Page_jump_Mode_Relative_Button.color = 0x33FF33
                    Page_jump_Mode_Absolute_Button.color = 0xFFFFFF
                    Edit_Box_draw_ALL(Page_jump_Edit_box_list_Abs,nil)
                    Button_draw_ALL({Page_jump_Mode_Absolute_Button,Page_jump_Mode_Relative_Button})
                elseif id == Page_jump_Hyper_Button.id then
                    Ship.enable(true)
                    Ship.command("HYPERDRIVE", true)
                elseif id == Page_jump_list_L_Button.id then
                    List_box_goto_page(GloBal_Offset_list_box,GloBal_Offset_list_box.page_now-1)
                    Page_jump_list_m_Button.txt = tostring(GloBal_Offset_list_box.page_now).."/"..tostring(List_box_get_max_page(GloBal_Offset_list_box))
                    draw_List_box(GloBal_Offset_list_box,false)
                elseif id == Page_jump_list_R_Button.id then
                    List_box_goto_page(GloBal_Offset_list_box,GloBal_Offset_list_box.page_now+1)
                    Page_jump_list_m_Button.txt = tostring(GloBal_Offset_list_box.page_now).."/"..tostring(List_box_get_max_page(GloBal_Offset_list_box))
                    draw_List_box(GloBal_Offset_list_box,false)
                elseif id == Page_jump_list_m_Button.id then
                    flush_P()
                elseif id == Page_jump_list_Save_Button.id then
                    if GloBal_Offset_list_box.hot ~= 1 then
                        Cheak_void()
                        do
                            local tmpb2 = { ["tag"] = Page_jump_c_name_Edit_box.txt,
                                            ["Front"] = Page_jump_c_Front_Edit_box.txt,
                                            ["Right"] = Page_jump_c_Right_Edit_box.txt,
                                            ["Up"] = Page_jump_c_Up_Edit_box.txt,
                                            ["Rot"] = Page_jump_C_Rot_Box.hot_side}
                            G_P_C[GloBal_Offset_list_box.hot - 1] = serialization.serialize(tmpb2)
                        end
                    else
                        Page_jump_c_name_Edit_box.txt = "Ship Core"
                        Page_jump_c_Front_Edit_box.txt = "0"
                        Page_jump_c_Right_Edit_box.txt = "0"
                        Page_jump_c_Up_Edit_box.txt = "0"
                        Page_jump_C_Rot_Box.hot_side = "A"
                    end
                    save_P()
                    flush_P()
                    draw_Rot_Box(Page_jump_C_Rot_Box)
                elseif id == Page_jump_list_Add_Button.id then
                    Cheak_void()
                    do
                        local tmpb2 = { ["tag"] = Page_jump_c_name_Edit_box.txt,
                                        ["Front"] = Page_jump_c_Front_Edit_box.txt,
                                        ["Right"] = Page_jump_c_Right_Edit_box.txt,
                                        ["Up"] = Page_jump_c_Up_Edit_box.txt,
                                        ["Rot"] = Page_jump_C_Rot_Box.hot_side}
                        table.insert(G_P_C,GloBal_Offset_list_box.hot,serialization.serialize(tmpb2))
                    end
                    save_P()
                    Page_jump_c_name_Edit_box.txt = "Ship Core"
                    Page_jump_c_Front_Edit_box.txt = "0"
                    Page_jump_c_Right_Edit_box.txt = "0"
                    Page_jump_c_Up_Edit_box.txt = "0"
                    Page_jump_C_Rot_Box.hot_side = "A"
                    flush_P()
                    draw_Rot_Box(Page_jump_C_Rot_Box)
                    --todo
                elseif id == Page_jump_list_Rm_Button.id then
                    Page_jump_c_name_Edit_box.txt = "Ship_Core"
                    Page_jump_c_Front_Edit_box.txt = "0"
                    Page_jump_c_Right_Edit_box.txt = "0"
                    Page_jump_c_Up_Edit_box.txt = "0"
                    Page_jump_C_Rot_Box.hot_side = "A"
                    if GloBal_Offset_list_box.hot ~= 1 then
                        table.remove(G_P_C,GloBal_Offset_list_box.hot - 1)
                    end
                    save_P()
                    flush_P()
                    draw_Rot_Box(Page_jump_C_Rot_Box)
                end
                hot_edit_box_id = nil
                Edit_Box_draw_ALL(Page_jump_Edit_box_list_Abs,hot_edit_box_id)
            elseif type == "Edit_box" then
                hot_edit_box_id = id
                Edit_Box_draw_ALL(Page_jump_Edit_box_list_Abs,hot_edit_box_id)
            elseif type == "Rot_box" then
                hot_edit_box_id = id
                if id == Page_jump_Target_Rot_Box.id then
                    Page_jump_Target_Rot_Box.hot_side = Rot_box_get_click(Signal_Data[3],Signal_Data[4],Page_jump_Target_Rot_Box)
                    draw_Rot_Box(Page_jump_Target_Rot_Box)
                    draw_txt_from_Rot_Box(Page_jump_Target_Rot_Box,0x000000)
                elseif id == Page_jump_Local_Rot_Box.id then
                    do
                        local l_x,_,l_y = Ship.getOrientation()
                        Page_jump_Local_Rot_Box.hot_side = Rot_Plus(get_local_rot(l_x,l_y),Page_jump_C_Rot_Box.hot_side)
                    end

                    draw_Rot_Box(Page_jump_Local_Rot_Box)
                    draw_txt_from_Rot_Box(Page_jump_Local_Rot_Box,0x000000)
                elseif id == Page_jump_C_Rot_Box.id then
                    Page_jump_C_Rot_Box.hot_side = Rot_box_get_click(Signal_Data[3],Signal_Data[4],Page_jump_C_Rot_Box)
                    do
                        local l_x,_,l_y = Ship.getOrientation()
                        Page_jump_Local_Rot_Box.hot_side = Rot_Plus(get_local_rot(l_x,l_y),Page_jump_C_Rot_Box.hot_side)
                    end

                    draw_Rot_Box(Page_jump_Local_Rot_Box)
                    draw_txt_from_Rot_Box(Page_jump_Local_Rot_Box,0x000000)
                    draw_Rot_Box(Page_jump_C_Rot_Box)
                end
            elseif type == "List_box" then
                if id == GloBal_Offset_list_box.id then
                    GloBal_Offset_list_box.hot = List_box_get_click_abs(GloBal_Offset_list_box,Signal_Data[4])
                    if GloBal_Offset_list_box.hot == 1 then
                        Page_jump_c_name_Edit_box.txt = "Ship Core"
                        Page_jump_c_Front_Edit_box.txt = "0"
                        Page_jump_c_Right_Edit_box.txt = "0"
                        Page_jump_c_Up_Edit_box.txt = "0"
                        Page_jump_C_Rot_Box.hot_side = "A"
                    else
                        do
                            local tmpb2 = serialization.unserialize(G_P_C[GloBal_Offset_list_box.hot-1])
                            Page_jump_c_name_Edit_box.txt = tmpb2["tag"]
                            Page_jump_c_Front_Edit_box.txt = tmpb2["Front"]
                            Page_jump_c_Right_Edit_box.txt = tmpb2["Right"]
                            Page_jump_c_Up_Edit_box.txt = tmpb2["Up"]
                            Page_jump_C_Rot_Box.hot_side = tmpb2["Rot"]
                        end
                    end


                    do
                        local l_x,_,l_y = Ship.getOrientation()
                        Page_jump_Local_Rot_Box.hot_side = Rot_Plus(get_local_rot(l_x,l_y),Page_jump_C_Rot_Box.hot_side)
                    end

                    draw_Rot_Box(Page_jump_Local_Rot_Box)
                    draw_txt_from_Rot_Box(Page_jump_Local_Rot_Box,0x000000)

                    draw_List_box(GloBal_Offset_list_box,false)
                    draw_Rot_Box(Page_jump_C_Rot_Box)
                end
                hot_edit_box_id = nil
                Edit_Box_draw_ALL(Page_jump_Edit_box_list_Abs,hot_edit_box_id)
            else
                hot_edit_box_id = nil
                --todo

                local core_rot = ""
                do
                    local l_x,_,l_y = Ship.getOrientation()
                    core_rot = get_local_rot(l_x,l_y)
                    Page_jump_Local_Rot_Box.hot_side = Rot_Plus(core_rot,Page_jump_C_Rot_Box.hot_side)
                end

                draw_Rot_Box(Page_jump_Local_Rot_Box)
                draw_txt_from_Rot_Box(Page_jump_Local_Rot_Box,0x000000)

                local n_rel_Rot = get_rel_rot(Page_jump_Local_Rot_Box.hot_side,Page_jump_Target_Rot_Box.hot_side)
                local tran = {"A","B","C","D"}
                local str_rel_Rot = tran[n_rel_Rot+1]
                local relR = Rot_Plus(core_rot,str_rel_Rot)

                if G_jump_mode == "Relative" then

                    local lxz = fuck_xz(
                            { tonumber_ex(Page_jump_c_Front_Edit_box.txt),
                              tonumber_ex(Page_jump_c_Right_Edit_box.txt)},
                            {tonumber_ex(Page_jump_Abs_x_Edit_box.txt),
                             tonumber_ex(Page_jump_Abs_z_Edit_box.txt)}, relR
                    )

                    local x_z = fuck_xyz(lxz)
                    Ship.movement(x_z[1],
                            tonumber_ex(Page_jump_Abs_y_Edit_box.txt),
                            x_z[2])

                    Ship.rotationSteps(get_rel_rot(Page_jump_Local_Rot_Box.hot_side,Page_jump_Target_Rot_Box.hot_side))

                elseif G_jump_mode == "Absolute" then
                    local position = { Ship.getLocalPosition() }
                    local lxz = fuck_xz_2(
                            { tonumber_ex(Page_jump_c_Front_Edit_box.txt),
                              tonumber_ex(Page_jump_c_Right_Edit_box.txt)},
                            {tonumber_ex(Page_jump_Abs_x_Edit_box.txt),
                             tonumber_ex(Page_jump_Abs_z_Edit_box.txt)}, relR
                    )


                    local x_z = fuck_xyz(lxz)
                    Ship.movement(x_z[1],
                            tonumber_ex(Page_jump_Abs_y_Edit_box.txt) - position[2] - tonumber_ex(Page_jump_c_Up_Edit_box.txt),
                            x_z[2])

                    Ship.rotationSteps(get_rel_rot(Page_jump_Local_Rot_Box.hot_side,Page_jump_Target_Rot_Box.hot_side))
                end

                ship_isInHyper = Ship.isInHyperspace()
                if ship_isInHyper then
                    G_State = "Hyper"
                else
                    G_State = "World"
                end
                draw_txt(3,20,"State: "..G_State,0xDDDDDD,0x000000)
                Edit_Box_draw_ALL(Page_jump_Edit_box_list_Abs,hot_edit_box_id)
            end
        elseif Signal_Data[1] == "key_down" then
            if Signal_Data[4] == 0x0E then  --key: backspace
                Edit_Box_Backspace(Page_jump_Edit_box_list_Abs,hot_edit_box_id)
            else
                Edit_Box_editing(Page_jump_Edit_box_list_Abs,hot_edit_box_id,string.char(Signal_Data[3]))
                --todo
            end
        elseif Signal_Data[1] == nil then
            if component_reload() then
                local backup = GloBal_Offset_list_box.hot
                update()

            end
        end
    end
end

function Page_ship()
    local hot_edit_box_id = nil

    --GUI_init
    local Page_ship_Back_Button = CreateButton(1,23,10,3,0xFFFFFF,0x000000,"Back","B1")
    local Page_ship_Rebuild_Button = CreateButton(70,23,11,3,0xFFFFFF,0x000000,"ReBuild","B2")
    local Page_ship_reflush_Button = CreateButton(3,15,76,3,0xFFFFFF,0x000000,"ReFlush Ship Data","B3")
    local Page_ship_Name_Edit_box = Create_Edit_Box(16,3,61,0xFFFFFF,0x00FFFF,0x000000,"EN")
    local Page_ship_Front_Edit_box = Create_Edit_Box(16,5,22,0xFFFFFF,0x00FFFF,0x000000,"EF",char_number_only)
    local Page_ship_Right_Edit_box = Create_Edit_Box(16,7,22,0xFFFFFF,0x00FFFF,0x000000,"ER",char_number_only)
    local Page_ship_Up_Edit_box = Create_Edit_Box(16,9,22,0xFFFFFF,0x00FFFF,0x000000,"EU",char_number_only)
    local Page_ship_Back_Edit_box = Create_Edit_Box(55,5,22,0xFFFFFF,0x00FFFF,0x000000,"EB",char_number_only)
    local Page_ship_Left_Edit_box = Create_Edit_Box(55,7,22,0xFFFFFF,0x00FFFF,0x000000,"EL",char_number_only)
    local Page_ship_Down_Edit_box = Create_Edit_Box(55,9,22,0xFFFFFF,0x00FFFF,0x000000,"ED",char_number_only)

    local Page_ship_Edit_box_list = {
        Page_ship_Name_Edit_box,
        Page_ship_Front_Edit_box,
        Page_ship_Right_Edit_box,
        Page_ship_Up_Edit_box,
        Page_ship_Back_Edit_box,
        Page_ship_Left_Edit_box,
        Page_ship_Down_Edit_box
    }
    --GUI_init_end

    draw_rectangle(1,1,80,25,0xDDDDDD)
    draw_title(1,1,80,"Ship: "..Ship.name(),0xAAAAAA,0xFFFFFF)

    Page_ship_Name_Edit_box.txt = Ship.name()

    local Ship_posDim = { Ship.dim_positive() }
    local Ship_negDim = { Ship.dim_negative() }
    Page_ship_Front_Edit_box.txt = tostring(Ship_posDim[1])
    Page_ship_Right_Edit_box.txt = tostring(Ship_posDim[2])
    Page_ship_Up_Edit_box.txt = tostring(Ship_posDim[3])
    Page_ship_Back_Edit_box.txt = tostring(Ship_negDim[1])
    Page_ship_Left_Edit_box.txt = tostring(Ship_negDim[2])
    Page_ship_Down_Edit_box.txt = tostring(Ship_negDim[3])


    Button_draw_ALL({
        Page_ship_Back_Button,
        Page_ship_Rebuild_Button,
        Page_ship_reflush_Button
    })

    draw_txt(3,3,"Ship Name:",0xDDDDDD,0x000000)
    draw_txt(3,5,"Ship Front:",0xDDDDDD,0x000000)
    draw_txt(3,7,"Ship Right:",0xDDDDDD,0x000000)
    draw_txt(3,9,"Ship Up:",0xDDDDDD,0x000000)
    draw_txt(42,5,"Ship Back:",0xDDDDDD,0x000000)
    draw_txt(42,7,"Ship Left:",0xDDDDDD,0x000000)
    draw_txt(42,9,"Ship Down:",0xDDDDDD,0x000000)


    Edit_Box_draw_ALL(Page_ship_Edit_box_list,hot_edit_box_id)

    local function flush_data()
        local mass, volume = Ship.getShipSize()
        local xyz = { Ship.getLocalPosition() }
        draw_txt(3, 11,"Ship Mass:    "..tostring(mass),0xDDDDDD,0x000000)
        draw_txt(42,11,"Ship Volume:  "..tostring(volume),0xDDDDDD,0x000000)
        draw_txt(3, 13,"Ship Position:   "..tostring(xyz[1]).."  "..tostring(xyz[2]).."  "..tostring(xyz[3]),0xDDDDDD,0x000000)
    end

    flush_data()

    while true do
        local Signal_Data = { computer.pullSignal(5) }
        if Signal_Data[1] == "touch" then
            local type,id = Is_Button_click(Signal_Data[3],Signal_Data[4],{
                Page_ship_Back_Button,
                Page_ship_Rebuild_Button,
                Page_ship_reflush_Button,
                Page_ship_Name_Edit_box,
                Page_ship_Front_Edit_box,
                Page_ship_Right_Edit_box,
                Page_ship_Up_Edit_box,
                Page_ship_Back_Edit_box,
                Page_ship_Left_Edit_box,
                Page_ship_Down_Edit_box
            })

            if type == "Button" then
                if id == Page_ship_Back_Button.id then
                    break
                elseif id == Page_ship_Rebuild_Button.id then
                    Ship.name(Page_ship_Name_Edit_box.txt)
                    Ship.dim_positive(tonumber(Page_ship_Front_Edit_box.txt),tonumber(Page_ship_Right_Edit_box.txt),tonumber(Page_ship_Up_Edit_box.txt))
                    Ship.dim_negative(tonumber(Page_ship_Back_Edit_box.txt),tonumber(Page_ship_Left_Edit_box.txt),tonumber(Page_ship_Down_Edit_box.txt))
                    break
                elseif id == Page_ship_reflush_Button.id then
                    flush_data()
                end
                hot_edit_box_id = nil
                Edit_Box_draw_ALL(Page_ship_Edit_box_list,hot_edit_box_id)
            elseif type == "Edit_box" then
                hot_edit_box_id = id
                Edit_Box_draw_ALL(Page_ship_Edit_box_list,hot_edit_box_id)
            else
                hot_edit_box_id = nil
                Edit_Box_draw_ALL(Page_ship_Edit_box_list,hot_edit_box_id)
            end
        elseif Signal_Data[1] == "key_down" then
            if Signal_Data[4] == 0x0E then  --key: backspace
                Edit_Box_Backspace(Page_ship_Edit_box_list,hot_edit_box_id)
            else
                Edit_Box_editing(Page_ship_Edit_box_list,hot_edit_box_id,string.char(Signal_Data[3]))
            end
        elseif Signal_Data[1] == nil then
            component_reload()
        end
    end
end

function Page_home()
    local Ship_command,_ = Ship.command()
    --GUI_init
    local Page_home_Ship_Button = CreateButton(11,17,14,5,0xFFFFFF,0x000000,"Ship","B1")
    local Page_home_Jump_Button = CreateButton(26,17,14,5,0xFFFFFF,0x000000,"Jump","B2")
    local Page_home_Config_Button = CreateButton(41,17,14,5,0xFFFFFF,0x000000,"Config","B3")
    local Page_home_State_Button = CreateButton(56,17,14,5,0xFFD700,0xFF0000,Ship_command,"B4")
    local Page_home_Button_list = {
        Page_home_Ship_Button,
        Page_home_Jump_Button,
        Page_home_Config_Button,
        Page_home_State_Button
    }
    --GUI_init_end

    local function update()
        Ship_command,_ = Ship.command()
        Page_home_State_Button.txt = Ship_command
        if Ship_command == "MANUAL" then
            Page_home_State_Button.txtcolor = 0xFF0000
        end
        draw_rectangle(1,1,80,25,0xDDDDDD)
        draw_title(1,1,80,"Easy Warp - Home page",0xAAAAAA,0xFFFFFF)
        draw_LOGO(16,4)
        Button_draw_ALL(Page_home_Button_list)
        draw_txt(1,25,Version,0xDDDDDD,0x00FFFF)
        draw_txt(73,25,"By DFDYZ",0xDDDDDD,0x00FFFF)
    end

    update()

    while true do

        local Signal_Data = { computer.pullSignal(5) }
        if Signal_Data[1] == "touch" then
            local _,id = Is_Button_click(Signal_Data[3],Signal_Data[4],Page_home_Button_list)
            if id == Page_home_Ship_Button.id then
                Page_ship()
                update()
            elseif id == Page_home_Jump_Button.id then
                Page_jump()
                update()
            elseif id == Page_home_Config_Button.id then
                Page_Config()
                update()
            elseif id == Page_home_State_Button.id then
                Ship_command,_ = Ship.command()
                if Ship_command == "IDLE" then
                    Ship.command("OFFLINE", false)
                    Ship.command("OFFLINE", true)
                    Ship.enable(false)
                    Ship_command,_ = Ship.command()
                    Page_home_State_Button.txtcolor = 0xFF0000
                    Page_home_State_Button.txt = Ship_command
                    Button_draw(Page_home_State_Button)

                else
                    Ship.command("IDLE", false)
                    Ship.enable(true)
                    Ship.command("IDLE", true)
                    Ship_command,_ = Ship.command()
                    Page_home_State_Button.txtcolor = 0x00FFFF
                    Page_home_State_Button.txt = Ship_command
                    Button_draw(Page_home_State_Button)
                end
            end
        elseif Signal_Data[1] == nil then
            component_reload()
        end
    end
end

GUI_init_G()
Ship.command("MANUAL", false)
Page_home()

sleep(15)
