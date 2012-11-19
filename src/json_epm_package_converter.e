note
	description: "JSON converter for package."
	author: "Olivier Ligot"
	date: "$Date$"
	revision: "$Revision$"

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

    value: JSON_OBJECT

    object: EPM_PACKAGE

feature -- Conversion

    from_json (j: like value): detachable like object
        local
            l_name, l_version, l_description: STRING_32
            l_json_dependencies: HASH_TABLE [ANY, STRING_GENERAL]
            l_dependencies: DS_HASH_TABLE [STRING_32, STRING_32]
        do
            l_name ?= json.object (j.item (K_name), Void)
            l_version ?= json.object (j.item (K_version), Void)
            if l_name /= Void and l_version /= Void then
            	create Result.make (l_name, l_version)
            end
            l_description ?= json.object (j.item (K_description), Void)
            if l_description /= Void then
            	Result.set_description (l_description)
            end
            l_json_dependencies ?= json.object (j.item (K_dependencies), Void)
            if l_json_dependencies /= Void then
            	create l_dependencies.make_equal (l_json_dependencies.count)
            	across
            		l_json_dependencies as l_cursor
            	loop
            		if attached {STRING_32} l_cursor.key as l_key and attached {STRING_32} l_cursor.item as l_value then
            			l_dependencies.force_last (l_value, l_key)
            		end
            	end
            	Result.set_dependencies (l_dependencies)
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

end
