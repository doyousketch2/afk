
print( '[afk]  CSM loading...' )

local awaymessage  = "I'm AFK, try again later."

local playername  = ''
local nicknames  = {}
local pings  = {}
local afk  = false

--  https://raw.githubusercontent.com/minetest/minetest/master/doc/client_lua_api.txt
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

local function show_main_dialog()
  local formspec  = 'size[8,8]'
    ..'bgcolor[#080808BB]'
    ..'label[0.1,0;Away From Keyboard]'
    ..'button_exit[5.8,0.2;2.2,0.2;close;Close]'

    ..'tableoptions[background=#314D4F]'
    ..'tablecolumns[color;text,align=center,width=10]'
    ..'table[0,1;7.8,2.5;nick_list;'
  formspec  = formspec ..table .concat( nicknames, ',' ) ..';]'

    ..'tableoptions[background=#314D4F]'
    ..'tablecolumns[color;text,align=center,width=10]'
    ..'table[0,4;7.8,3.8;ping_list;'
  formspec  = formspec ..table .concat( pings, ',' ) ..';]'

  minetest .show_formspec(  'afk:menu',  formspec  )
end

--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

minetest .register_on_receiving_chat_messages(
  function(message)

  local msg  = minetest .strip_colors(message)

    if afk and msg :find( playername ) then

      if msg :sub( 1 ) == '<' then  --  normal message
        sender  = msg :sub( 2, msg :find( '>' -1 ) )
        table.insert( pings, '#000000,' ..sender )

      -- elseif  'player did some action'  then...
      end

      print( '[afk] found playername' )
      minetest .send_chat_message( awaymessage )
      show_main_dialog()
    end

  end
)

--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

minetest .register_on_formspec_input(
  function( formname, fields )
    if formname ~= 'afk:menu' then return false

    elseif fields .close then
      afk  = false
      print('[afk] CSM: returned')
    end

  end
)

--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

minetest .register_on_connect(
  function() -- outer
    -- delay a moment for Minetest to initialize
    minetest .after( 5,
      function() -- inner
        playername  = minetest .localplayer :get_name()
        table.insert( nicknames, '#000000,' ..playername )
        print( '[afk] playername ||' ..playername ..'||' )

        local lowercase  = string.lower( playername )
        if lowercase ~= playername then
          table.insert( nicknames, '#000000,' ..lowercase )
          print( '[afk] lowercase ||' ..lowercase ..'||' )
        end

        local lastchar  = #playername
        while tonumber( playername :sub(lastchar) )
          and lastchar > 1 do
            lastchar  = lastchar -1
        end
        local stripped  = string.sub( playername, 1, lastchar )
        if stripped ~= playername then
          table.insert( nicknames, '#000000,' ..stripped )
          print( '[afk] stripped ||' ..stripped ..'||' )
        end

        local lowerstrip  = string.lower( stripped )
        if lowerstrip ~= playername
          and lowerstrip ~= lowercase then
            table.insert( nicknames, '#000000,' ..lowerstrip )
            print( '[afk] lowerstrip ||' ..lowerstrip ..'||' )
        end

        local M1  = minetest .colorize( '#BBBBBB', '[afk] CSM loaded, type ' )
        local M2  = minetest .colorize( '#FFFFFF', '.afk ' )
        local M3  = minetest .colorize( '#BBBBBB', "when you're Away From Keyboard" )
        minetest .display_chat_message( M1..M2..M3 )

      end  -- function() -- inner
    )  -- .after(5)

  end  -- function() -- outer
)  -- .register_on_connect()

--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

minetest .register_chatcommand( 'afk',
  {
    func  = function(param)
      afk  = true
      print('[afk] CSM: away')
      show_main_dialog()
    end,
  }
)

--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
