part of ompa_common;

typedef Model ModelCreator(Map<String,dynamic> data);

class ModelFactory {
  Map<String,ModelCreator> models = {};
  
  Model create(String name, Map<String,dynamic> data){
    return models[name](data);
  }
  addCreateor(String name, ModelCreator creator){
    models['name'] = creator;
  }
}