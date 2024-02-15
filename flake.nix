{
    description = "The desktop files";

    outputs = { self, nixpkgs }: 
        let
        machineConfigs = {
            persistence = {
                envs = "persistence/config.env";
                machine_name = "persistence";
            };
            note = {
                envs = "note/config.env";
                machine_name = "note";
            };
        };
    in {

        persistence = 
            with import nixpkgs { system = "x86_64-linux"; };
        stdenv.mkDerivation rec {
            name = "ava-chamaleon";
            version = "0.7.25";

            src = self;

            builder = "${bash}/bin/bash";
            args = [ "${src}/builder.sh" ];
#  args = [ ./builder.sh ];

            baseInputs = [ coreutils ];

            meta = with lib; {
                description = "The files for the desktop enviromnetn";
                license = licenses.mit;
                maintainers = with maintainers; [ "alexvanaxe107" ];
            };
        };



        packages.x86_64-linux.default = self.persistence;
    };

}
