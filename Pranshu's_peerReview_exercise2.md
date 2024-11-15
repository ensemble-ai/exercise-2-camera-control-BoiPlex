# Peer-Review for Programming Exercise 2 #

By Pranshu Jindal

Student ID: 919719851

## Description ##

For this assignment, you will be giving feedback on the completeness of assignment two: Obscura. To do so, we will give you a rubric to provide feedback. Please give positive criticism and suggestions on how to fix segments of code.

You only need to review code modified or created by the student you are reviewing. You do not have to check the code and project files that the instructor gave out.

Abusive or hateful language or comments will not be tolerated and will result in a grade penalty or be considered a breach of the UC Davis Code of Academic Conduct.

If there are any questions at any point, please email the TA.   

## Due Date and Submission Information
See the official course schedule for due date.

A successful submission should consist of a copy of this markdown document template that is modified with your peer review. This review document should be placed into the base folder of the repo you are reviewing in the master branch. The file name should be the same as in the template: `CodeReview-Exercise2.md`. You must also include your name and email address in the `Peer-reviewer Information` section below.

If you are in a rare situation where two peer-reviewers are on a single repository, append your UC Davis user name before the extension of your review file. An example: `CodeReview-Exercise2-username.md`. Both reviewers should submit their reviews in the master branch.  

# Solution Assessment #

## Peer-reviewer Information

* *name:* Pranshu Jindal 
* *email:* pajindal@ucdavis.edu

### Description ###

For assessing the solution, you will be choosing ONE choice from: unsatisfactory, satisfactory, good, great, or perfect.

The break down of each of these labels for the solution assessment.

#### Perfect #### 
    Can't find any flaws with the prompt. Perfectly satisfied all stage objectives.

#### Great ####
    Minor flaws in one or two objectives. 

#### Good #####
    Major flaw and some minor flaws.

#### Satisfactory ####
    Couple of major flaws. Heading towards solution, however did not fully realize solution.

#### Unsatisfactory ####
    Partial work, not converging to a solution. Pervasive Major flaws. Objective largely unmet.


___

## Solution Assessment ##

### Stage 1 ###

- [ ] Perfect
- [x] Great
- [ ] Good
- [ ] Satisfactory
- [ ] Unsatisfactory

___
#### Justification ##### 
The implementation for stage 1 does a nice job of fulfilling the primary requirements. The camera successfully locks to the vessel's position on the x and z axes, ensuring it remains centered. The cross is correctly drawn using a 5x5 unit size when draw_camera_logic is enabled, and the [mesh is properly cleaned up after one frame.](https://github.com/ensemble-ai/exercise-2-camera-control-BoiPlex/blob/53981a36b2f7acbc813336a998c3e3c75e78e829/Obscura/scripts/camera_controllers/position_lock.gd#L56) However, the code could benefit from better comments to clarify specific parts of the implementation, such as the purpose of dynamically creating the cross mesh. Additionally, ensuring all edge cases (for example, null target) are handled would make it more robust. Overall, the functionality works well for the assignment.

___
### Stage 2 ###

- [x] Perfect
- [ ] Great
- [ ] Good
- [ ] Satisfactory
- [ ] Unsatisfactory

___
#### Justification ##### 
The implementation for stage 2 does a good job. It introduces horizontal auto-scrolling and frame-bound controls. The exported fields top_left, bottom_right, and autoscroll_speed are well-defined and functional, allowing customization of the scrolling behavior. Also, The camera properly scrolls on the x and z axes and maintains the target within the defined frame boundaries. To note, [this code ensures that the target moves consistently with the frame's auto-scroll speed](https://github.com/ensemble-ai/exercise-2-camera-control-BoiPlex/blob/53981a36b2f7acbc813336a998c3e3c75e78e829/Obscura/scripts/camera_controllers/horizontal_auto_scroll.gd#L36).

___
### Stage 3 ###

- [x] Perfect
- [ ] Great
- [ ] Good
- [ ] Satisfactory
- [ ] Unsatisfactory

___
#### Justification ##### 
The implementation for Stage 3 does a wonderful job. The camera smoothly follows the target using linear interpolation (lerp) with the specified follow_speed and catchup_speed, maintaining the desired game feel. It correctly enforces the leash_distance to keep the camera constrained and avoids abrupt jumps. [The draw_logic() function accurately creates and displays the center cross, fulfilling the visual requirement](https://github.com/ensemble-ai/exercise-2-camera-control-BoiPlex/blob/53981a36b2f7acbc813336a998c3e3c75e78e829/Obscura/scripts/camera_controllers/lerp_smoothing_position_lock.gd#L58). The center cross is accurately drawn when draw_camera_logic is enabled, meeting the visual feedback requirement. Additionally, the camera updates based on whether the target is moving or stationary, showing clear separation of cases for improved clarity. Finally, [The usage of lerp to smoothly update the camera position when the target is stationary is well-implemented](https://github.com/ensemble-ai/exercise-2-camera-control-BoiPlex/blob/53981a36b2f7acbc813336a998c3e3c75e78e829/Obscura/scripts/camera_controllers/lerp_smoothing_position_lock.gd#L29).


___
### Stage 4 ###

- [ ] Perfect
- [x] Great
- [ ] Good
- [ ] Satisfactory
- [ ] Unsatisfactory

___
#### Justification ##### 
The implementation for stage 4 does a nice job of fulfilling most of the requirements. The code effectively handles the target focus with lerp smoothing. It successfully moves the camera in the direction of the player's input (global_position += target.velocity * delta) and catches up smoothly to the player after a delay (_catchup_timer is used for this purpose). [Moreover, it Implements delay before catching up and the timer ensures the camera doesn't immediately snap to the target when the player stops moving](https://github.com/ensemble-ai/exercise-2-camera-control-BoiPlex/blob/53981a36b2f7acbc813336a998c3e3c75e78e829/Obscura/scripts/camera_controllers/lerp_smoothing_target_focus.gd#L34). It Correctly moves the camera with the target's velocity; This ensures the camera stays responsive to the player's movements. Furthermore, it correctly draws the 5x5 cross when logic is enabled. The draw_logic method correctly draws the 5x5 cross in the center of the screen when draw_camera_logic is enabled. [Also, the camera smoothly follows the player after delay: This uses lerp to provide a smooth following effect when the player is stationary](https://github.com/ensemble-ai/exercise-2-camera-control-BoiPlex/blob/53981a36b2f7acbc813336a998c3e3c75e78e829/Obscura/scripts/camera_controllers/lerp_smoothing_target_focus.gd#L36). However, the implementation could benefit from improved edge case handling such as null or invalid target states. For Example, you can add a conditional check to ensure target is not null before accessing its velocity or position.


___
### Stage 5 ###

- [x] Perfect
- [ ] Great
- [ ] Good
- [ ] Satisfactory
- [ ] Unsatisfactory

___
#### Justification ##### 
 The implementation for stage 5 does a perfect job. It implements a 4-way speedup push zone with proper logic for camera movement based on the target's position and velocity. The camera's movement ratio relative to the target is well-handled using the exported variable push_ratio. This allows smooth control over how much the camera catches up to the target. Moreover, The calculation of differences (diff_left_from_center, etc.) and conditions for determining camera movement are handled comprehensively, ensuring the camera behaves as described in the stage requirements. The camera's dynamic adjustment based on whether the target is inside, near, or at the edges of the zones ensures robust behavior. For instance, the push_x and push_z calculations handle different cases for left, right, top, and bottom boundaries. [Also, the _draw_box() method is used effectively to render both the outer pushbox and the speedup zone, meeting the requirement to visualize the zones](https://github.com/ensemble-ai/exercise-2-camera-control-BoiPlex/blob/53981a36b2f7acbc813336a998c3e3c75e78e829/Obscura/scripts/camera_controllers/speedup_push_zone.gd#L100).
___
# Code Style #


### Description ###
Check the scripts to see if the student code adheres to the GDScript style guide.

If sections do not adhere to the style guide, please peramlink the line of code from Github and justify why the line of code has not followed the style guide.

It should look something like this:

* [description of infraction](https://github.com/dr-jam/ECS189L) - this is the justification.

Please refer to the first code review template on how to do a permalink.


#### Style Guide Infractions ####

[The variable _catchup_timer in Stage 4](https://github.com/ensemble-ai/exercise-2-camera-control-BoiPlex/blob/53981a36b2f7acbc813336a998c3e3c75e78e829/Obscura/scripts/camera_controllers/lerp_smoothing_target_focus.gd#L10) - It does not follow the PascalCase naming convention recommended for class-level variables in GDScript. Using PascalCase ensures consistency with other class-level variables and constants in the codebase.

[The variable _pushbox in Stage 5](https://github.com/ensemble-ai/exercise-2-camera-control-BoiPlex/blob/53981a36b2f7acbc813336a998c3e3c75e78e829/Obscura/scripts/camera_controllers/speedup_push_zone.gd#L13C1-L13C29) -  GDScript style guide discourages using underscores for private variables, as GDScript doesn't enforce access modifiers like private. The convention is to use PascalCase for all class-level variables regardless of visibility.


[The variable catchup_delay_duration in Stage 4](https://github.com/ensemble-ai/exercise-2-camera-control-BoiPlex/blob/53981a36b2f7acbc813336a998c3e3c75e78e829/Obscura/scripts/camera_controllers/lerp_smoothing_target_focus.gd#L5) - The variable name is unnecessarily long, making the code harder to read. According to the style guide, variable names should be concise yet descriptive. For example, CatchupDelay is shorter but conveys the same meaning.

#### Style Guide Exemplars ####

[The function name draw_logic in Stage 4](https://github.com/ensemble-ai/exercise-2-camera-control-BoiPlex/blob/53981a36b2f7acbc813336a998c3e3c75e78e829/Obscura/scripts/camera_controllers/lerp_smoothing_target_focus.gd#L46) - It has a descriptive name that clearly indicate its purpose. The GDScript style guide recommends using clear and concise function names to enhance readability, which this code achieves.

[The Constant DEFAULT_PUSHBOX_SIZE in Stage 5](https://github.com/ensemble-ai/exercise-2-camera-control-BoiPlex/blob/53981a36b2f7acbc813336a998c3e3c75e78e829/Obscura/scripts/camera_controllers/speedup_push_zone.gd#L4) -  It is used effectively to define a default value for the pushboxzone size, ensuring the value is easily configurable and clearly understood.


[The function lerp used in a line in Stage 3](https://github.com/ensemble-ai/exercise-2-camera-control-BoiPlex/blob/53981a36b2f7acbc813336a998c3e3c75e78e829/Obscura/scripts/camera_controllers/lerp_smoothing_position_lock.gd#L37) - The lerp() function is used effectively in multiple scenarios to smoothly interpolate the camera's position toward the target. This ensures the camera movement feels natural and responsive to the player’s movements.

[The @export used in Stage 4](https://github.com/ensemble-ai/exercise-2-camera-control-BoiPlex/blob/53981a36b2f7acbc813336a998c3e3c75e78e829/Obscura/scripts/camera_controllers/lerp_smoothing_target_focus.gd#L7) - The use of @export here follows the GDScript style guide by allowing designers to configure leash_distance directly in the editor without altering the script.

[The Use of Await in Stage 1](https://github.com/ensemble-ai/exercise-2-camera-control-BoiPlex/blob/53981a36b2f7acbc813336a998c3e3c75e78e829/Obscura/scripts/camera_controllers/position_lock.gd#L55C2-L55C32) - The use of await ensures the temporary mesh is properly cleaned up after the next frame, preventing unnecessary memory usage or potential leaks.

[Using _pushbox Dictionary in Stage 5](https://github.com/ensemble-ai/exercise-2-camera-control-BoiPlex/blob/53981a36b2f7acbc813336a998c3e3c75e78e829/Obscura/scripts/camera_controllers/speedup_push_zone.gd#L20) - Using dictionaries to group related variables improves readability and structure, following the GDScript style guide's focus on clarity and organization.

___

# Best Practices #

### Description ###

If the student has followed best practices then feel free to point at these code segments as examplars. 

If the student has breached the best practices and has done something that should be noted, please add the infraction.


This should be similar to the Code Style justification.

#### Best Practices Infractions ####
[The repeated creation and cleanup of MeshInstance3D objects in draw_logic() might impact performance. You should consider optimizing by reusing these objects](https://github.com/ensemble-ai/exercise-2-camera-control-BoiPlex/blob/53981a36b2f7acbc813336a998c3e3c75e78e829/Obscura/scripts/camera_controllers/lerp_smoothing_target_focus.gd#L46).

[Variables like push_ratio](https://github.com/ensemble-ai/exercise-2-camera-control-BoiPlex/blob/53981a36b2f7acbc813336a998c3e3c75e78e829/Obscura/scripts/camera_controllers/speedup_push_zone.gd#L7) and [pushbox_top_left do not have checks to ensure valid values](https://github.com/ensemble-ai/exercise-2-camera-control-BoiPlex/blob/53981a36b2f7acbc813336a998c3e3c75e78e829/Obscura/scripts/camera_controllers/speedup_push_zone.gd#L8). For example, push_ratio should not be negative. If this value is negative, the camera could move in the opposite direction, leading to erratic behavior.

Complex sections, such as calculating diff and distance or implementing lerp logic, lack comments explaining the purpose and behavior of these calculations. So do key areas like calculating the difference between target and camera positions or determining boundaries.

[The draw_logic() function re-implements box-drawing logic similar to earlier stages without creating a reusable method. This violates best practices because we are not supposed to repeat.](https://github.com/ensemble-ai/exercise-2-camera-control-BoiPlex/blob/53981a36b2f7acbc813336a998c3e3c75e78e829/Obscura/scripts/camera_controllers/horizontal_auto_scroll.gd#L60)


#### Best Practices Exemplars ####

[The use of dictionaries to define pushbox and speedup zone boundaries in Stage 5 is a clean and extensible way to handle boundary definitions](https://github.com/ensemble-ai/exercise-2-camera-control-BoiPlex/blob/53981a36b2f7acbc813336a998c3e3c75e78e829/Obscura/scripts/camera_controllers/speedup_push_zone.gd#L13C1-L14C34). This approach improves both readability and maintainability by grouping related boundary values into a single structure. Instead of handling multiple separate variablesthe dictionaries centralize this data, allowing for easier updates and modifications.

[Super calls in _ready() and _process() ensure proper initialization](https://github.com/ensemble-ai/exercise-2-camera-control-BoiPlex/blob/53981a36b2f7acbc813336a998c3e3c75e78e829/Obscura/scripts/camera_controllers/lerp_smoothing_target_focus.gd#L13) and maintain the parent class functionality. [The use of super() calls in the _ready() and _process() methods](https://github.com/ensemble-ai/exercise-2-camera-control-BoiPlex/blob/53981a36b2f7acbc813336a998c3e3c75e78e829/Obscura/scripts/camera_controllers/lerp_smoothing_target_focus.gd#L43) demonstrates adherence to good object-oriented programming principles. These calls are essential for ensuring that the functionality of the parent class is properly initialized and maintained, which promotes clean and extensible code design.

[The _draw_box() method ensures reusability because the same function is used to draw multiple boundary boxes, avoiding repetitive code. It also ensures readability, since the logic for drawing the box is separated into a dedicated method, making the main draw_logic function cleaner. Lastly, it ensures extensibility since if additional types of boxes or drawing logic are required, this method can be easily adapted.](https://github.com/ensemble-ai/exercise-2-camera-control-BoiPlex/blob/53981a36b2f7acbc813336a998c3e3c75e78e829/Obscura/scripts/camera_controllers/speedup_push_zone.gd#L115)

The logic for determining the camera's movement based on the target's position relative to the pushbox and speedup zone is well-structured and follows a systematic approach. The use of conditional checks to calculate push_x and push_z ensures that the camera's behavior follows stage requirements.