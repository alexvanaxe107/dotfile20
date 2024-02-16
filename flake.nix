{
    description = "The desktop files";

    outputs = { self, nixpkgs }: 
        let
        version = "0.8.00";
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
            inherit version;

            src = self;

            builder = "${bash}/bin/bash";
            args = [ "${src}/builder.sh" ];

            envs = machineConfigs.persistence.envs;
            machine_name = machineConfigs.persistence.machine_name;

            baseInputs = [ coreutils ];

            meta = with lib; {
                description = "The files for the desktop enviromnetn";
                license = licenses.mit;
                maintainers = with maintainers; [ "alexvanaxe107" ];
            };
        };

        note = 
            with import nixpkgs { system = "x86_64-linux"; };
        stdenv.mkDerivation rec {
            name = "ava-chamaleon";
            inherit version;

            src = self;

            builder = "${bash}/bin/bash";
            args = [ "${src}/builder.sh" ];

            envs = machineConfigs.note.envs;
            machine_name = machineConfigs.note.machine_name;

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
