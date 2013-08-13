function clean(input,aggressiveMode){
    var json = $.parseJSON(input);
    var cleaned = cleanJSON(json,aggressiveMode);
    return JSON.stringify(cleaned,null,4);
}

function cleanJSON(input,aggressiveMode){
    var master = {};
    master[input[1]] = input[4];
    var c = cleanObject(master);
    var t = trimObject(c,0,aggressiveMode);
    return t;
}

function cleanObject(object){
    for(var key in object){
        if(object.hasOwnProperty(key)){
            var value = object[key];

            //strip out list metadata
            if(key == 'lst'){
                value = value.splice(2);
            }

            //strip out map metadata
            if(key == 'map'){
                value = value.splice(3);
            }

            if(typeof value === 'object'){
                object[key] = cleanObject(value);
            }

            //bubble up values
            switch(key){
                case 'tf':
                case 'str':
                case 'i32':
                case 'dbl':
                    return value;
            }
        }
    }
    return object;
}

function trimObject(object,depth,aggressiveMode){

    var unwantedKeys = ['rec','lst','map'];

    if(typeof object == 'object'){
        var keys = Object.keys(object);
        if(keys.length == 1 && depth !== 0 && !Array.isArray(object)){
            var k = keys[0];
            if(aggressiveMode || unwantedKeys.indexOf(k) != -1){
                return trimObject(object[k],depth+1,aggressiveMode);
            }else{
                trimObject(object[k],depth+1,aggressiveMode);
                return object;
            }
        }else{
            for(var key in object){
                object[key] = trimObject(object[key],depth+1,aggressiveMode);
            }
            return object;
        }
    }
    return object;
}

// -- Thrift parsing, unused:

function parseThriftStruct(struct){
    var container = {};
    container.name = struct.match(/struct (\w*)/)[1];
    container.object = {};
    var properties = struct.match(/\d:\s?(?:required)?[\s<\w\.,>]* (\w*)/g);
    for(var i=0;i<properties.length;i++){
        property = properties[i];
        var key = property[0];
        var name = property.match(/\d:\s?(?:required)?[\s<\w\.,>]* (\w*)/)[1];
        container.object[key] = name;
    }
    return container;
}

function parseThriftService(service){
    var container = {};
    container.name = service.match(/service (\w*)/)[1];
    container.object = {};
    var methods = service.match(/[<,\w>]*\s*\w*\(.*\)/g);
    for(var i=0;i<methods.length;i++){
        method = methods[i];
        var name = method.match(/(\w*)\(\)/);
        var type = method.match(/^\s*(\w*)[\s<\w\.,>]*\w*\(.*\)/)[1];
        container.object[name] = type;
    }
    return container;
}

function readFile(file,callback){
    var fr = new FileReader();
    fr.onload = function(){
        callback(fr.result);
    };
    fr.readAsText(file);
}

function parseThriftBody(input){
    var structs = input.match(/(struct[\s\S]*?{[\s\S]*?})/g);
    var services = input.match(/(service[\s\S]*?{[\s\S]*?})/g);
    var thrift = {};
    for(var i=0;i<structs.length;i++){
        string = structs[i];
        container = parseThriftStruct(string);
        thrift[container.name] = container.object;
    }
    for(var i=0;i<services.length;i++){
        string = services[i];
        container = parseThriftService(string);
        thrift[container.name] = container.object;
    }
    return thrift;
}