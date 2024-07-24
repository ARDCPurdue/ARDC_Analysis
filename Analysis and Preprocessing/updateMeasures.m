% function to decide what measures to use based on the protocol selected.
% update when changing fields.ProtocolName

function [newfields] = updateMeasures(p_measure, params, protocolDropdown, fields,labels, MEAS)

global fields

selectedProtocol = protocolDropdown.Value;
measures = table2array(MEAS(ismember(MEAS.(selectedProtocol), 1),1));
devices = table2array(MEAS(ismember(MEAS.(selectedProtocol), 1), 2));

fields = rmfield(fields, "meas");
labels = rmfield(labels, "meas");
delete(p_measure.Children)
%load default data:
measures = table2array(MEAS(ismember(MEAS.(fields.ProtocolName.Value), 1),1));
devices = table2array(MEAS(ismember(MEAS.(fields.ProtocolName.Value), 1), 2));

location = fields.location.Value;
room = fields.location_rm.Value; 
equip_file = sprintf('Equipment_%s_%s.csv', location, room);
opts = detectImportOptions(equip_file);
opts = setvaropts(opts, 3, "Type", 'datetime','InputFormat','MM/dd/uuuu', 'TreatAsMissing', 'NA');
opts = setvaropts(opts, 2, "Type", 'string', 'TreatAsMissing', 'NA');
Equipment = readtable(equip_file, opts);

p_x = 5:params.input_width+params.border*1.5:params.app_width;
p_y = [params.border/2+295 params.border/2];
x = 5;
y = 300-params.sect_height:-params.sect_height:0;

for j = 1:length(measures)
    measure = measures{j};
    device = devices{j};
    if j > 4  % handle if length(measures) > 4 so that there are two rows
        k = 2;
        i = j - 4;
    else
        k = 1;
        i = j;
    end

    p_meas(j) = uipanel(p_measure, 'Title', measure, 'TitlePosition', 'centertop', ...
        'Position', [p_x(i), p_y(k), params.input_width+params.border, 290],...
        "BackgroundColor", '#c4bfc0', 'FontWeight', 'bold');

    serNum = table2array(Equipment(strcmp(device,Equipment.Device), "SerialNum"));
    calDate = table2array(Equipment(strcmp(device,Equipment.Device), end));
    labels.meas.(measure).com = uilabel(p_meas(j), 'Text', 'Comments', 'Position',[x, y(1), params.input_width, params.input_height]);
    fields.meas.(measure).comment = uitextarea(p_meas(j), 'Value', '', 'Position',[x, y(1)-params.input_height-params.inpsz, params.input_width, params.input_height*2]);
    % labels.meas.(measure).protocol = uilabel(p_meas(j), 'Text', 'Protocol', 'Position',[x, y(3), params.input_width, params.input_height]);
    % fields.meas.(measure).protocol = uidropdown(p_meas(j), "Items",{'Conventional', 'Other'}, 'Position',[x, y(3)-params.inpsz, params.input_width, params.input_height]);
    labels.meas.(measure).equipment = uilabel(p_meas(j), 'Text', 'Equipment', 'Position',[x, y(4), params.input_width, params.input_height]');
    fields.meas.(measure).equipment.device = uieditfield(p_meas(j), "Value", device , 'Position',[x, y(4)-params.inpsz, params.input_width, params.input_height-5]);
    fields.meas.(measure).equipment.serialNumber = uieditfield(p_meas(j), "Value", string(serNum) , 'Position',[x, y(4)-2*params.inpsz, params.input_width, params.input_height-5]);
    fields.meas.(measure).equipment.calibDate = uieditfield(p_meas(j), "Value", string(calDate) , 'Position',[x, y(4)-3*params.inpsz, params.input_width, params.input_height-5]);
end
end