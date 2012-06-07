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
        end

    to_json (o: like object): like value
        do
            create Result.make
            Result.put (json.value (o.name), K_name)
            Result.put (json.value (o.version), K_version)
            if o.description /= Void then
            	Result.put (json.value (o.description), K_description)
            end
        end

feature {NONE} -- Implementation

	K_name: JSON_STRING
		do
			create Result.make_json ("name")
		end

	K_version: JSON_STRING
		do
			create Result.make_json ("version")
		end

	K_description: JSON_STRING
		do
			create Result.make_json ("description")
		end

end
