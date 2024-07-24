% function to decide what equipment sheet to use based on the location.
% update when changing fields.location
function updateRoom(fields, MEAS, locations, rms)

global fields

warning('off')

fields.location_rm.Items = rms(strcmp(locations, fields.location.Value)); 
selectedRoom = fields.location_rm.Value;

protocol = fields.ProtocolName.Value;
measures = table2array(MEAS(ismember(MEAS.(protocol), 1),1));
devices = table2array(MEAS(ismember(MEAS.(protocol), 1), 2));

equip_file = sprintf('Equipment_%s_%s.csv', fields.location.Value, selectedRoom);
opts = detectImportOptions(equip_file);
opts = setvaropts(opts, (3:numel(opts.VariableNames)), 'InputFormat','MM/dd/uuuu', 'TreatAsMissing', 'NA');
opts = setvaropts(opts, 2, "Type", 'string');
Equipment = readtable(equip_file, opts);

for i = 1:size(measures,1)
    meas = measures(i);
    device = devices(i);
    serNum = table2array(Equipment(strcmp(device,Equipment.Device), "SerialNum"));
    calDate = table2array(Equipment(strcmp(device,Equipment.Device), end));
    fields.meas.(meas).equipment.device.Value = device;
    fields.meas.(meas).equipment.serialNumber.Value = string(serNum);
    fields.meas.(meas).equipment.calibDate.Value = string(calDate);
end
end
