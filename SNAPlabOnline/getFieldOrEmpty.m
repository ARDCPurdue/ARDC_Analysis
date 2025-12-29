function value = getFieldOrEmpty(s, fieldname)
    if isfield(s, fieldname)
        value = s.(fieldname);
    else
        value = [];
    end
end