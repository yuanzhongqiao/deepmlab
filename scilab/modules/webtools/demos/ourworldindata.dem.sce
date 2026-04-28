// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2023 - Dassault Systèmes S.E. - Clément DAVID
//
// This file is released under the 3-clause BSD license. See COPYING-BSD.

function demo_ourworldindata()
    listbox = get("demo_ourworldindata_listbox");

    if listbox <> [] && is_handle_valid(listbox) then
        // callback mode

        // clear screen
        my_handle = get("demo_ourworldindata");
        a = get("demo_ourworldindata_axes");
        if a.children <> [] then
            delete(a.children);
        end
        
        // reset axes
        a.data_bounds(2,2) = 0;

        // extract data to display
        data = listbox.userdata;
        countries = fieldnames(data);
        selected = listbox.value;
        selected_countries = countries(selected);
    else
        // without argument, this is the gui creation
        my_handle = figure(..
            "figure_name", "COVID data from OurWorldInData", ..
            "background", -2, ..
            "default_axes", "off", ..
            "layout", "border", ..
            "tag", "demo_ourworldindata");
        demo_viewCode("ourworldindata.dem.sce");
    
        // load the data
        my_handle.info_message = "Downloading data";
        if ~isfile("TMPDIR/owid-covid-data.csv") then
            http_get("https://covid.ourworldindata.org/data/owid-covid-data.csv", "TMPDIR/owid-covid-data.csv", follow=%t);
        end
        
        // reformat data as vectors stored in a single struct
        my_handle.info_message = "Reformat the data";
        fields = ["icu_patients_per_million" "excess_mortality_cumulative_per_million" "hosp_patients_per_million"]

        [S, header] = csvRead("TMPDIR/owid-covid-data.csv", ',', [], 'string', [], [], [], 1);
        header = strsplit(header, ',')';

        data = struct();
        for c=unique(S(:, 3))'
            mask = S(:,3) == c;
            data(c).date = datenum(csvTextScan(S(mask, "date" == header), "-"));
            for f=fields
                data(c)(f) = strtod(S(mask, f == header));
                data(c)(f)(isnan(data(c)(f))) = 0;
            end
        end
        my_handle.info_message = "Setup UI";

        // define variables
        countries = fieldnames(data);
        selected = 1:min(5, size(countries, 1));
        selected_countries = countries(selected);

        // change colormap
        my_handle.color_map =[0 0 1;
            0 0.5 0;
            1 0 0;
            0 0.75 0.75;
            .75 0 .75;
            .75 .75 0;
            .25 .25 .25;
            0 0 0];
        // insert axes
        cframe = uicontrol(my_handle, "style", "frame", 'constraints', createConstraints('border', 'center'));
        a = newaxes(cframe);
        a.tag = "demo_ourworldindata_axes";
        // insert the checkbox and selection listbox
        lframe = uicontrol(my_handle, "style", "frame", 'constraints', createConstraints('border', 'left'), 'layout', 'border');
        tlframe = uicontrol(lframe, "style", "frame", 'constraints', createConstraints('border', 'top'), 'layout', 'gridbag');
        for i=1:size(fields, 2)
            uicontrol(tlframe, 'style', 'radiobutton', ..
                'callback', 'demo_ourworldindata', ..
                'constraints', createConstraints('gridbag', [1 i 1 1]), ..
                'string', fields(i), ..
                'groupname', "indicator", ..
                'max', i);
        end
        tlframe.children($).value = 1;

        listbox = uicontrol(lframe, 'style', 'listbox', ..
                            'callback', 'demo_ourworldindata', ..
                            'constraints', createConstraints('border', 'left'), ..
                            'max', size(countries, 1), ..
                            'string', countries, ..
                            'value', selected, ..
                            'tag', 'demo_ourworldindata_listbox');
        listbox.userdata = data;
    end
    
    // plot the selected countries
    my_handle.info_message = "Plotting";
    nbCol = size(my_handle.color_map,1);
    sca(a);
    indicators = findobj('groupname', "indicator");
    indicator = indicators.string(indicators.value <> 0);
    for i=selected
        t = data(countries(i)).date;
        n = data(countries(i))(indicator);
        [?,kv] = gsort(t, 'g', 'i');
        
        t = t(kv);
        v = n(kv);
        plot2d(t, v, modulo(i-1,nbCol)+1);
        [?, j] = max(v);
        xstring(t(j), v(j), countries(i));
        gce().clip_state = "off";
    end
    
    my_handle.info_message = "";
endfunction

demo_ourworldindata()
