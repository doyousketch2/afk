
print( '[afk]  CSM loading...' )

local player1name  = ''

--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

local function show_main_dialog()

  local formspec  = 'size[6,8]'
    ..'bgcolor[#080808BB]'
    ..'label[0.1,0;Away From Keyboard]'
    ..'button_exit[4,0.5;2.2,0.2;close;Close]'

  minetest .show_formspec(  'afk:menu',  formspec  )
end

--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

minetest .register_on_receiving_chat_messages(
  function(message)

    local msg  = minetest .strip_colors(message)

    if msg :find( player1name ) then
      minetest .send_chat_message( "I'm AFK, try again later." )
    end

  end
)

--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

minetest .register_on_connect(
  function() -- 1
    -- delay a moment for Minetest to initialize
    minetest .after( 7,
      function() -- 2
        player1name  = minetest .localplayer :get_name()

        local M1  = minetest .colorize( '#BBBBBB', '[afk] CSM loaded, type ' )
        local M2  = minetest .colorize( '#FFFFFF', '.afk ' )
        local M3  = minetest .colorize( '#BBBBBB', "when you're Away From Keyboard" )
        minetest .display_chat_message( M1..M2..M3 )

      end  -- function() -- 2
    )  -- .after(7)

  end  -- function() -- 1
)  -- .register_on_connect()

--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

minetest .register_chatcommand( 'afk',
  {
    func  = function(param)
      shown  = true
      show_main_dialog()
    end,
  }
)

--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
