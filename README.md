[![OpenSource](https://img.shields.io/badge/Open-Source-orange.svg)](https://github.com/doyousketch2)  [![Minetest](https://img.shields.io/badge/Download-Minetest-brightgreen.svg)](https://www.minetest.net)  [![PythonVersions](https://img.shields.io/badge/Lua-LuaJIT-blue.svg)](https://www.lua.org)  [![License](https://img.shields.io/badge/license-GPL-lightgrey.svg)](https://www.gnu.org/licenses/gpl-3.0.en.html)  [![Git.io](https://img.shields.io/badge/Git.io-fxYWo-233139.svg)](https://git.io/fxYWo) 


## afk  
Auto responder, for when you're Away From Keyboard, while playing Minetest

Completed:
- [x] keep a list of who tried to message you, while you were away
- [x] menu, so you can add common nicknames
- [x] save nicknames
 
known limitations:  
- [ ] you can't use this with another CSM that has custom message responses.  
  it appears minetest only allows one instance of  *.register_on_receiving_chat_messages()*  
  so it won't work with my [friendly_chat] CSM, or another one that colors chat    
  but I'll probably merge the functions, so all this code will end up in [friendly_chat]  

Todo:  
- [ ] custom response messages  
  kinda~sorta already implimented, might make a menu for it  
  there's a random list you can easily edit in the *init.lua* file.  

## Install:  
unzip in your **/minetest/clientmods/** folder  
> rename folder so it just says **afk** instead of *afk-master*  

open your mods.conf file in notepad++  
> or any other text editor that respects unix line-endings.  
> add the line **load_mod_afk = true**  
> save and close that file

if you haven't enabled CSM's yet:
> in your file explorer, go up one folder level  
> so you're now in your **/minetest/** directory  
> look for your **minetest.conf** file and open it in notepad++ or similar  
> if you don't have the line **enable_client_modding = true** then add it  
> save and exit.  enjoy minetest.  
