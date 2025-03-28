function toggleMeasureFields(checkbox, event, measureFields, panel)
isEnabled = checkbox.Value;
measureFields.comment.Enable = ~isEnabled;
measureFields.equipment.calibDate.Enable = ~isEnabled;
measureFields.equipment.device.Enable = ~isEnabled;
measureFields.equipment.serialNumber.Enable = ~isEnabled;

% if isEnabled
%     panel.BackgroundColor = 'k'; % Adjust colors as needed
% else
%     panel.BackgroundColor = '#c4bfc0';
% end
end
