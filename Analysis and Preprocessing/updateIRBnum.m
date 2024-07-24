% Update IRB number based on the PI that was selected.
function updateIRBnum(referringDropdown, irbnumEditField, irbData)

selectedLab = referringDropdown.Value;
idx = find(strcmp(irbData.PI, selectedLab));
if ~isempty(idx)
    irbNumber = irbData.IRBnum(idx);
    irbnumEditField.Value = irbNumber;
else
    irbnumEditField.Value = 'IRB not found'; % Handle if lab not found in IRB data
end

end
