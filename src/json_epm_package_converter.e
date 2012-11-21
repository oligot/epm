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

    value: detachable JSON_OBJECT

    object: EPM_PACKAGE

feature -- Conversion

    from_json (j: attached like value): detachable like object
        local
            l_dependencies: DS_HASH_TABLE [EPM_PACKAGE_DEPENDENCY, STRING_32]
            l_dependency: EPM_PACKAGE_DEPENDENCY
        do
            if attached {STRING_32} json.object (j.item (K_name), Void) as l_name and
            	attached {STRING_32} json.object (j.item (K_version), Void) as l_version then
            	create Result.make (l_name, l_version)
	            if attached {STRING_32} json.object (j.item (K_description), Void) as l_description then
	            	Result.set_description (l_description)
	            end
	            if attached {HASH_TABLE [detachable ANY, STRING_GENERAL]} json.object (j.item (K_dependencies), Void) as l_json_dependencies then
	            	create l_dependencies.make_equal (l_json_dependencies.count)
	            	across
	            		l_json_dependencies as l_cursor
	            	loop
	            		if attached {STRING_32} l_cursor.key as l_key and attached {STRING_32} l_cursor.item as l_value then
	            			create l_dependency.make (l_value)
	            			l_dependencies.force_last (l_dependency, l_key)
	            		end
	            	end
	            	Result.set_dependencies (l_dependencies)
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

end
