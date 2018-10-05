
print( '[afk]  CSM loading...' )

--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

--  "message in quotes",  followed by a comma

local awaymessages  = {
  "brb",
  "bbiab",
  "just a sec...",
  "be right back",
  "currently afk.",
  "away for a few.",
  "be back in a bit",
  "hang on a minute...",
  "away from keyboard.",
  "afk, try again later.",
  "afk, please try again later.",
  "not at my keyboard right now.",
  "please leave a message at the beep...",
}

--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

local playername  = ''
local nicknames  = {}
local nickname  = ''
local pings  = {}
local afk  = false
local index  = ''
local selected  = ''
local savednames  = ''
local prev_random  = ''
local last_msg_from  = ''

--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

local mod_storage  = minetest .get_mod_storage()

--  uncomment next line to PRINT out the contents of [afk] mod_storage.
--print( dump( mod_storage :to_table() ))

--  WARNING:  uncomment the next line to COMPLETELY CLEAR [afk] mod_storage, if need be.
--mod_storage :from_table()

--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

--  https://raw.githubusercontent.com/minetest/minetest/stable-0.4/doc/client_lua_api.md

--  https://raw.githubusercontent.com/minetest/minetest/master/doc/client_lua_api.txt

--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

math .randomseed( minetest .get_us_time() )
math.random(); math.random(); math.random()

local function show_main_dialog()
  local formspec  = 'size[12,8]'
    ..'bgcolor[#080808CC]'

    ..'field[0.3,0.8;8.2,0.2;nick;add nickname;]'
    ..'button_exit[9,0.2;2.2,0.2;close;Close]'

    ..'tableoptions[color=#000000;background=#314D4F]'
    ..'tablecolumns[text]'
    ..'table[0,1.3;8,2.5;nick_list;'
  formspec  = formspec ..table .concat( nicknames, ',' ) ..';]'

    ..'button[9,2.5;2.2,0.2;remove;Remove]'

    ..'tableoptions[color=#000000;background=#314D4F]'
    ..'tablecolumns[text]'
    ..'table[0,4;11.8,3.8;ping_list;'
  formspec  = formspec ..table .concat( pings, ',' ) ..';]'

  minetest .show_formspec(  'afk:menu',  formspec  )
end

--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

minetest .register_on_receiving_chat_messages(
  function(message)

    local msg  = minetest .strip_colors(message)
    local found  = false

    for na = 1, #nicknames do
      if afk and not found and msg :find( nicknames[na] ) then

        if msg :sub( 1, 1 ) == '<' then  --  normal message
          local sender  = msg :sub( 2,  msg :find( '>' ) -1 )

          if sender ~= playername then
            print( '[afk] msg: ' ..msg )
            table.insert( pings, msg )

            local random  = math.random( #awaymessages )
            while random == prev_random do
              random  = math.random( #awaymessages )
            end
            local awaymessage  = awaymessages[ random ]
            if sender == last_msg_from then
              whisper  = '/msg ' ..sender ..' ' ..awaymessage
              minetest .send_chat_message( whisper )
            else
              minetest .send_chat_message( awaymessage )
            end
            prev_random  = random
            last_msg_from  = sender

            show_main_dialog()
            found  = true
          end

        -- elseif  'player did some action'  then...
        end  -- if msg :sub

      end  -- if afk

    end  -- for name
  end  -- function(message)
)

--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

local function bracket( title,  variable )
  print( '[afk] '..title ..' ||' ..variable ..'||' )
end

--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

minetest .register_on_formspec_input(
  function( formname, fields )
    if formname ~= 'afk:menu' then return false

    elseif fields .close then
      selected  = ''
      afk  = false
      print('[afk] CSM: returned')

    elseif fields .nick_list then  -- figure out which name was selected
      local sel  = fields .nick_list  -- CHG:row:col for singleclick  or  DBL:row:col for doubleclick
      local click  = sel :sub(1,3)
      if click == 'CHG' or click == 'DBL' then  -- example, when you change the field, it returns  CHG:12:3
        -- get # from first ':'  @ pos 5.   possibility of 2 digits require you to find() the second ':'
        local ind  = sel :sub( 5,  sel :find(':', 6) -1 )
        index  = tonumber( ind )

        selected  = nicknames[ index ]
        show_main_dialog()
      end  -- if click ==

    elseif fields .key_enter_field then
      local newname  = fields .nick
      print( newname )
      table.insert( nicknames,  newname )
      print( '[afk] CSM added: ' ..newname )

      local na  = table .concat( nicknames, ' ' )
      mod_storage :set_string( playername, na )
      minetest .after(  0.1,  function() show_main_dialog() end  )

    elseif fields .remove and index > 1 then
        table.remove( nicknames,  index )
        print( '[afk] CSM removed: ' ..selected )

        index  = index -1
        selected  = nicknames[ index ]
        show_main_dialog()
    end

  end  -- function( formname, fields )
)

--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

minetest .register_on_connect(
  function() -- outer
    -- delay a moment for Minetest to initialize
    minetest .after( 3,
      function() -- inner
        playername  = minetest .localplayer :get_name()

    xpcall(  function() savednames  = mod_storage :get_string( playername ) end, 
             function() savednames  = '' end  )

        if savednames ~= '' then  -- every na between space
          for na in string.gmatch( savednames, '%S+' ) do
            table.insert( nicknames, na )
          end

        else
          table.insert( nicknames, playername )
          bracket( 'playername', playername )

          local lowercase  = string.lower( playername )
          if lowercase ~= playername then
            table.insert( nicknames, lowercase )
            bracket( 'lowercase', lowercase )
          end

          local lastchar  = #playername
          while tonumber( playername :sub(lastchar) )
            and lastchar > 1 do
              lastchar  = lastchar -1
          end
          local stripped  = string.sub( playername, 1, lastchar )
          if stripped ~= playername then
            table.insert( nicknames, stripped )
            bracket( 'stripped', stripped )
          end

          local lowerstrip  = string.lower( stripped )
          if lowerstrip ~= playername
            and lowerstrip ~= lowercase then
              table.insert( nicknames, lowerstrip )
              bracket( 'lowerstrip', lowerstrip )
          end

          local nn  = table .concat( nicknames, ' ' )
          mod_storage :set_string( playername, nn )
        end  -- savednames

        local M1  = minetest .colorize( '#BBBBBB', '[afk] CSM loaded, type ' )
        local M2  = minetest .colorize( '#FFFFFF', '.afk ' )
        local M3  = minetest .colorize( '#BBBBBB', "when you're Away From Keyboard" )
        minetest .display_chat_message( M1..M2..M3 )

      end  -- function() -- inner
    )  -- .after(3)

  end  -- function() -- outer
)  -- .register_on_connect()

--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

minetest .register_chatcommand( 'afk',
  {
    func  = function(param)
      afk  = true
      print('[afk] CSM: away')
      show_main_dialog()
    end
  }
)

--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
