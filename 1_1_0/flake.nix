{
  description = ''Syndicated actors for conversational concurrency'';

  inputs.flakeNimbleLib.owner = "riinr";
  inputs.flakeNimbleLib.ref   = "master";
  inputs.flakeNimbleLib.repo  = "nim-flakes-lib";
  inputs.flakeNimbleLib.type  = "github";
  inputs.flakeNimbleLib.inputs.nixpkgs.follows = "nixpkgs";
  
  inputs.src-syndicate-1_1_0.flake = false;
  inputs.src-syndicate-1_1_0.owner = "~ehmry";
  inputs.src-syndicate-1_1_0.ref   = "1_1_0";
  inputs.src-syndicate-1_1_0.repo  = "syndicate-nim";
  inputs.src-syndicate-1_1_0.type  = "sourcehut";
  
  inputs."nimsha2".owner = "nim-nix-pkgs";
  inputs."nimsha2".ref   = "master";
  inputs."nimsha2".repo  = "nimsha2";
  inputs."nimsha2".dir   = "";
  inputs."nimsha2".type  = "github";
  inputs."nimsha2".inputs.nixpkgs.follows = "nixpkgs";
  inputs."nimsha2".inputs.flakeNimbleLib.follows = "flakeNimbleLib";
  
  inputs."preserves".owner = "nim-nix-pkgs";
  inputs."preserves".ref   = "master";
  inputs."preserves".repo  = "preserves";
  inputs."preserves".dir   = "v3_2_0";
  inputs."preserves".type  = "github";
  inputs."preserves".inputs.nixpkgs.follows = "nixpkgs";
  inputs."preserves".inputs.flakeNimbleLib.follows = "flakeNimbleLib";
  
  outputs = { self, nixpkgs, flakeNimbleLib, ...}@deps:
  let 
    lib  = flakeNimbleLib.lib;
    args = ["self" "nixpkgs" "flakeNimbleLib" "src-syndicate-1_1_0"];
  in lib.mkRefOutput {
    inherit self nixpkgs ;
    src  = deps."src-syndicate-1_1_0";
    deps = builtins.removeAttrs deps args;
    meta = builtins.fromJSON (builtins.readFile ./meta.json);
  };
}