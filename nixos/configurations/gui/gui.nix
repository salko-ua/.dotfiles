{ pkgs, ... }:
{
   # ENABLE AUTO LOGIN
   services.displayManager.autoLogin = {
     enable = true;
     user = "salo";
   };
   
   services.xserver = {
     enable = true;
     excludePackages = [ pkgs.xterm ];
   };
}
