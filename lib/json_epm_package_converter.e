note
	description: "JSON converter for package."
	author: "Olivier Ligot"

class
	JSON_EPM_PACKAGE_CONVERTER

inherit
    JSON_CONVERTER

create
    make

feature {NONE} -- Initialization

    make
        do
            create object.make ("json", "1.0.0")
        end

feature -- Access

    value: detachable JSON_OBJECT

    object: EPM_PACKAGE

feature -- Conversion

    from_json (j: attached like value): detachable like object
        do
            if attached {STRING_32} json.object (j.item (K_name), Void) as l_name and
            	attached {STRING_32} json.object (j.item (K_version), Void) as l_version then
            	create Result.make (l_name, l_version)
                if attached {STRING_32} json.object (j.item (K_description), Void) as l_description then
                    Result.set_description (l_description)
                end
                if attached {JSON_OBJECT} j.item (K_dependencies) as l_json_dependencies then
                	across
                		l_json_dependencies.current_keys as l_keys
                	loop
                		if attached {JSON_STRING} l_json_dependencies.item (l_keys.item) as l_value then
                            Result.dependencies.force_last (create {EPM_PACKAGE_DEPENDENCY}.make (l_value.item), l_keys.item.item)
                        end
                	end
                end
                if attached {STRING_32} json.object (j.item (K_env), Void) as l_env then
                    Result.set_environment_variable (l_env)
                end
            end
        end

    to_json (o: like object): like value
        do

        end

feature {NONE} -- Implementation

	K_name: STRING = "name"
	K_version: STRING = "version"
	K_description: STRING = "description"
	K_dependencies: STRING = "dependencies"
	K_env: STRING = "env"

end
