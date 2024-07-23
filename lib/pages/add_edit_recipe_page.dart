import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:scarpetta/components/adaptive_navigator.dart';
import 'package:scarpetta/components/category_indicator.dart';
import 'package:scarpetta/model/category.dart';
import 'package:scarpetta/model/ingredient.dart';
import 'package:scarpetta/model/recipe.dart';
import 'package:scarpetta/model/recipe_step.dart';
import 'package:scarpetta/model/unit.dart';
import 'package:scarpetta/providers&state/recipes_provider.dart';
import 'package:scarpetta/util/breakpoint.dart';
import 'package:scarpetta/util/open_categories.dart';

class AddEditRecipePage extends StatefulWidget {
  final Recipe? recipeToEdit;
  final Function(Recipe recipe)? onSubmit;

  const AddEditRecipePage({super.key, this.recipeToEdit, this.onSubmit});

  @override
  _AddEditRecipePageState createState() => _AddEditRecipePageState();
}

class _AddEditRecipePageState extends State<AddEditRecipePage> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  String _description = '';
  List<RecipeIngredient> _ingredients = [];
  List<RecipeStep> _steps = [];
  List<Map<String, TextEditingController>> _ingredientControllers = [];
  List<TextEditingController> _stepControllers = [];
  List<Category> _categories = [];

  @override
  void initState() {
    super.initState();

    _name = widget.recipeToEdit?.name ?? '';
    _description = widget.recipeToEdit?.description ?? '';
    _ingredients = widget.recipeToEdit?.ingredients ?? [];
    _steps = widget.recipeToEdit?.steps ?? [];
    _categories = widget.recipeToEdit?.categories ?? [];

    widget.recipeToEdit?.ingredients.forEach((ingredient) {
      _ingredientControllers.add({
        "amount": TextEditingController(text: ingredient.quantity.toString()),
        "unit": TextEditingController(text: ingredient.unit.abbreviation),
        "ingredient": TextEditingController(text: ingredient.ingredient.name),
      });
    });

    widget.recipeToEdit?.steps.forEach((step) {
      _stepControllers.add(TextEditingController(text: step.description));
    });

    if (_ingredients.isEmpty) {
      _addIngredient();
    }

    if (_steps.isEmpty) {
      _addStep();
    }
  }

  void _addIngredient() {
    setState(() {
      _ingredientControllers.add({
        "amount": TextEditingController(),
        "unit": TextEditingController(),
        "ingredient": TextEditingController(),
      });
    });
  }

  void _removeIngredient(int index) {
    setState(() {
      _ingredientControllers.removeAt(index);
      if (_ingredientControllers.isEmpty) {
        _addIngredient();
      }
    });
  }

  void _addStep() {
    setState(() {
      _stepControllers.add(TextEditingController());
    });
  }

  void _removeStep(int index) {
    setState(() {
      _stepControllers.removeAt(index);
      if (_stepControllers.isEmpty) {
        _addStep();
      }
    });
  }

  Future<void> _submitForm() async {
    print("SUBMIT FORM CALLED");
    if (_formKey.currentState!.validate()) {
      print("Form validation passed");

      _formKey.currentState!.save();

      print("Form saved");
      
      _ingredients = _ingredientControllers.map((ingredientControllers){
        return RecipeIngredient(
          name: ingredientControllers['ingredient']!.text,
          quantity: double.parse(ingredientControllers['amount']!.text),
          unit: Unit(abbreviation: ingredientControllers['unit']!.text),
        );
      }).toList();

      print("ingredients $_ingredients");

      _steps = _stepControllers.map((stepController){
        return RecipeStep(
          description: stepController!.text,
        );
      }).toList();

      print("steps $_steps");

      final newRecipe = Recipe(
        name: _name,
        authorId: FirebaseAuth.instance.currentUser?.uid,
        description: _description,
        ingredients: _ingredients,
        steps: _steps,
        categories: _categories,
      );
      
      print("New recipe $newRecipe");

      if (widget.onSubmit != null) {
        if (widget.recipeToEdit != null) {
          widget.onSubmit!(newRecipe.copyWith(
            id: widget.recipeToEdit!.id,
            imageUrl: widget.recipeToEdit!.imageUrl,
            authorId: widget.recipeToEdit!.authorId,
          ));
        } else {
          widget.onSubmit!(newRecipe);
        }

        Navigator.pop(context);
      }

    } else {
      print("Form validation failed");
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    bool isMobile = true;
    if (width > Breakpoint.md) {
      isMobile = false;
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: Text(widget.recipeToEdit == null ? 'Add New Recipe' : "Edit Recipe"),
        actions: [
          IconButton(
            icon: const PhosphorIcon(PhosphorIconsRegular.x),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          const SizedBox(width: 10.0),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          _submitForm();
        }, 
        icon: const PhosphorIcon(PhosphorIconsRegular.check),
        label: const Text('Save Recipe'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 40.0, right: 40.0, top: 20.0, bottom: 100.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  initialValue: _name,
                  decoration: const InputDecoration(
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                    hintText: 'Recipe name',
                    border: InputBorder.none,
                  ),
                  style: Theme.of(context).textTheme.displaySmall,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a name';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _name = value!;
                  },
                ),
                const SizedBox(height: 20.0),
                TextFormField(
                  initialValue: _description,
                  maxLines: 10,
                  minLines: 3,
                  expands: false,
                  decoration: InputDecoration(
                    isDense: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    labelText: 'Description'
                  ),
                  onSaved: (value) {
                    _description = value!;
                  },
                ),
                const SizedBox(height: 20.0),
                Text("Categories", style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 10.0),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: _categories.map((category) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5.0),
                        child: Stack(
                          clipBehavior: Clip.none,
                          alignment: Alignment.topRight,
                          children: [
                            CategoryIndicator(category: category, size: 60),
                            Positioned(
                              top: -17,
                              right: -17,
                              child: IconButton(
                                padding: EdgeInsets.zero,
                                icon: PhosphorIcon(
                                  PhosphorIconsFill.minusCircle, 
                                  //size: 40.0, 
                                  color: Theme.of(context).colorScheme.error
                                ),
                                onPressed: () {
                                  setState(() {
                                    _categories.remove(category);
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 10.0),
                ElevatedButton(
                  onPressed: () {
                    openCategories(
                      context: context, 
                      isMobile: isMobile, 
                      push: false,
                      onCategoryTap: (category) {
                        Navigator.pop(context);
                        setState(() {
                          if (_categories.firstWhere((item) => item.id == category.id, orElse: () => Category(name: "Not found")).name == "Not found") {
                            _categories.add(category);
                          }
                        });
                      }
                    );
                  },
                  child: const Text('Add Category'),
                ),
                const SizedBox(height: 25.0),
                const Divider(),
                const SizedBox(height: 25.0),
                Text(
                  'Ingredients',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                ..._ingredientControllers.map((ingredientControllers) {
                  int index = _ingredientControllers.indexOf(ingredientControllers);
                  return Column(
                    children: [
                      const SizedBox(height: 10.0),
                      Row(
                        children: [
                          SizedBox(
                            width: 65.0,
                            child: TextFormField(
                              controller: ingredientControllers['amount'],
                              decoration: const InputDecoration(
                                labelText: 'Amount',
                                hintText: '100',
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'An amount is missing';
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(width: 10.0),
                          SizedBox(
                            width: 35.0,
                            child: TextFormField(
                              controller: ingredientControllers['unit'],
                              decoration: const InputDecoration(
                                labelText: 'Unit',
                                hintText: 'g',
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'A unit is missing';
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(width: 10.0),
                          Expanded(
                            child: TextFormField(
                              controller: ingredientControllers['ingredient'],
                              decoration: const InputDecoration(
                                labelText: 'Ingredient',
                                hintText: 'Flour',
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'An ingredient is missing';
                                }
                                return null;
                              },
                            ),
                          ),
                          IconButton(
                            icon: PhosphorIcon(
                              PhosphorIconsFill.minusCircle,
                              color: Theme.of(context).colorScheme.error,
                            ),
                            onPressed: () => _removeIngredient(index),
                          ),
                        ],
                      ),
                    ],
                  );
                }).toList(),
                const SizedBox(height: 20.0),
                ElevatedButton(
                  onPressed: () {
                    _addIngredient();
                  },
                  child: const Text('Add Ingredient'),
                ),
                const SizedBox(height: 25.0),
                const Divider(),
                const SizedBox(height: 25.0),
                Text(
                  'Steps',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                ..._stepControllers.map((controller) {
                  int index = _stepControllers.indexOf(controller);
                  return Column(
                    children: [
                      const SizedBox(height: 15.0),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            backgroundColor: Theme.of(context).colorScheme.secondary,
                            child: Text(
                              '${index + 1}',
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: Theme.of(context).colorScheme.onSecondary,
                              ),
                            ),
                          ),
                          const SizedBox(width: 10.0),
                          Expanded(
                            child: Stack(
                              clipBehavior: Clip.none,
                              children: [
                                TextFormField(
                                  maxLines: 10,
                                  minLines: 1,
                                  controller: controller,
                                  decoration: InputDecoration(
                                    isDense: true,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    labelText: 'Step ${index + 1}'
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'A recipe step is missing';
                                    }
                                    return null;
                                  },
                                ),
                                Positioned(
                                  right: -20,
                                  top: -20,
                                  child: IconButton(
                                    icon: PhosphorIcon(
                                      PhosphorIconsFill.minusCircle,
                                      color: Theme.of(context).colorScheme.error,
                                    ),
                                    onPressed: () => _removeStep(index),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          
                        ],
                      ),
                    ],
                  );
                }).toList(),
                const SizedBox(height: 20.0),
                ElevatedButton(
                  onPressed: () {
                    _addStep();
                  },
                  child: const Text('Add Step'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
