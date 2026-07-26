let
  isNixFile = name: builtins.match ".*\\.nix" name != null;
  pipe = builtins.foldl' (x: f: f x);

  collect = dir:
    pipe dir [
      builtins.readDir
      (builtins.mapAttrs (
        name: type:
          if type == "directory"
          then collect (dir + "/${name}")
          else if isNixFile name
          then [(dir + "/${name}")]
          else []
      ))
      builtins.attrValues
      builtins.concatLists
    ];
in
  collect
