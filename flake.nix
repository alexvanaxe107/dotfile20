{
    description = "The desktop files";

    outputs = { self, nixpkgs }: 
        let
        version = "1.01";
        machineConfigs = {
            persistence = {
                envs = "persistence/config.env";
                machine_name = "persistence";
            };
            jason = {
                envs = "jason/config.env";
                machine_name = "jason";
            };
            note = {
                envs = "note/config.env";
                machine_name = "note";
            };
            gaming = {
                envs = "gaming/config.env";
                machine_name = "gaming";
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

        jason = 
            with import nixpkgs { system = "x86_64-linux"; };
        stdenv.mkDerivation rec {
            name = "ava-chamaleon";
            inherit version;

            src = self;

            builder = "${bash}/bin/bash";
            args = [ "${src}/builder.sh" ];

            envs = machineConfigs.jason.envs;
            machine_name = machineConfigs.jason.machine_name;

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

        gaming = 
            with import nixpkgs { system = "x86_64-linux"; };
        stdenv.mkDerivation rec {
            name = "ava-gaming";
            inherit version;

            src = self;

            builder = "${bash}/bin/bash";
            args = [ "${src}/fun_builder.sh" ];

            envs = machineConfigs.gaming.envs;
            machine_name = machineConfigs.gaming.machine_name;

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
