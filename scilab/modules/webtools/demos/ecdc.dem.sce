// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2023 - Dassault Systèmes S.E. - Clément DAVID
//
// This file is released under the 3-clause BSD license. See COPYING-BSD.

function demo_ecdc()
    listbox = get("demo_ecdc_listbox");

    if listbox <> [] && is_handle_valid(listbox) then
        // callback mode

        // clear screen
        my_handle = get("demo_ecdc");
        a = get("demo_ecdc_axes");
        if a.children <> [] then
            delete(a.children);
        end
        
        // reset axes
        a.data_bounds(2,2) = 0;
        
        // extract data to display
        data = listbox.userdata;
        countries = unique(data.country);
        selected = listbox.value;
        selected_countries = countries(selected);
    else
        // without argument, this is the gui creation
        my_handle = figure(..
            "figure_name", "COVID data from ECDC", ..
            "background", -2, ..
            "default_axes", "off", ..
            "layout", "border", ..
            "tag", "demo_ecdc");
        demo_viewCode("ecdc.dem.sce");
    
        // load the data
        my_handle.info_message = "Downloading data";

        data = http_get("https://opendata.ecdc.europa.eu/covid19/nationalcasedeath/json/");

        // reformat data as vectors stored in a single struct, this is not needed if your data have always the same fields.
        my_handle.info_message = "Reformat the data";
        default_values.country = "";
        default_values.country_code = "";
        default_values.continent = "";
        default_values.population = 0;
        default_values.indicator = "";
        default_values.weekly_count = 0;
        default_values.year_week = "";
        default_values.cumulative_count = 0;
        default_values.source = "";
        default_values.note = "";
        vars = fieldnames(default_values);
        execstr(vars + "(1:length(data)) =  default_values(""" + vars + """)");
        for i=1:length(data)
            fields = intersect(fieldnames(data(i)), vars)';
            execstr(fields + "(i) = data(i)." + fields);
        end
        execstr("data = struct("+strcat(""""+vars+""", "+vars, ', ') + ")");

        my_handle.info_message = "Setup UI";

        // define variables
        countries = unique(data.country);
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
        a.tag = "demo_ecdc_axes";
        // insert the checkbox and selection listbox
        lframe = uicontrol(my_handle, "style", "frame", 'constraints', createConstraints('border', 'left'), 'layout', 'border');
        tlframe = uicontrol(lframe, "style", "frame", 'constraints', createConstraints('border', 'top'), 'layout', 'gridbag');
        indicator = unique(data.indicator);
        for i=1:size(indicator, 1)
            uicontrol(tlframe, 'style', 'radiobutton', ..
                'callback', 'demo_ecdc', ..
                'constraints', createConstraints('gridbag', [i 1 1 1]), ..
                'string', indicator(i), ..
                'groupname', "indicator", ..
                'max', i);
        end
        tlframe.children($).value = 1;

        listbox = uicontrol(lframe, 'style', 'listbox', ..
                            'callback', 'demo_ecdc', ..
                            'constraints', createConstraints('border', 'left', [150 200]), ..
                            'max', size(countries, 1), ..
                            'string', countries, ..
                            'value', selected, ..
                            'tag', 'demo_ecdc_listbox');
        listbox.userdata = data;
    end
    
    // plot the selected countries
    my_handle.info_message = "Plotting";
    nbCol = size(my_handle.color_map,1);
    sca(a);
    
    for i=selected
        indicators = findobj('groupname', "indicator");
        mask = data.country == countries(i) & data.indicator == indicators.string(indicators.value <> 0);
        
        t = strtod(data.year_week(mask)) + strtod(part(data.year_week(mask), 6:$))/52;
        n = data.weekly_count(mask);
        [?,kv] = gsort(t, 'g', 'i');
        
        t = t(kv);
        s = cumsum(n(kv)) ./ data.population(mask);

        plot2d(t, s, modulo(i-1,nbCol)+1);
        xstring(t($), s($), countries(i));
        gce().clip_state = "off"
    end
    
    my_handle.info_message = "";
endfunction

demo_ecdc()
