/*
 * UBC CPSC 314, 2021WT1
 * Assignment 2 Template
 */

// Setup and return the scene and related objects.
// You should look into js/setup.js to see what exactly is done here.
const {
  renderer,
  scene,
  camera,
  worldFrame,
} = setup();

/////////////////////////////////
//   YOUR WORK STARTS BELOW    //
/////////////////////////////////

// Initialize uniforms

const lightOffset = { type: 'v3', value: new THREE.Vector3(0.0, 5.0, 5.0) };

const rotationMatrix = {type: 'mat4', value: new THREE.Matrix4()};

const time = {type: 'float', value: 0}

// Materials: specifying uniforms and shaders

const armadilloMaterial = new THREE.ShaderMaterial({
  uniforms: {
    lightOffset: lightOffset,
    rotationMatrix: rotationMatrix,
  }
});

const sphereMaterial = new THREE.ShaderMaterial({
  uniforms: {
    time: time,
  }
});

const eyeMaterial = new THREE.ShaderMaterial();

const armadilloFrame = new THREE.Object3D();
armadilloFrame.position.set(0, 0, -8);

scene.add(armadilloFrame);

const transformationMatrixR = {type: 'mat4', value: new THREE.Matrix4()};
const transformationMatrixL = {type: 'mat4', value: new THREE.Matrix4()};

// Load shaders.
const shaderFiles = [
  'glsl/armadillo.vs.glsl',
  'glsl/armadillo.fs.glsl',
  'glsl/sphere.vs.glsl',
  'glsl/sphere.fs.glsl',
  'glsl/eye.vs.glsl',
  'glsl/eye.fs.glsl'
];

new THREE.SourceLoader().load(shaderFiles, function (shaders) {
  armadilloMaterial.vertexShader = shaders['glsl/armadillo.vs.glsl'];
  armadilloMaterial.fragmentShader = shaders['glsl/armadillo.fs.glsl'];

  sphereMaterial.vertexShader = shaders['glsl/sphere.vs.glsl'];
  sphereMaterial.fragmentShader = shaders['glsl/sphere.fs.glsl'];

  eyeMaterial.vertexShader = shaders['glsl/eye.vs.glsl'];
  eyeMaterial.fragmentShader = shaders['glsl/eye.fs.glsl'];
});

// Load and place the Armadillo geometry.
loadAndPlaceOBJ('obj/armadillo.obj', armadilloMaterial, armadilloFrame, function (armadillo) {
  armadillo.rotation.y = Math.PI;
  armadillo.position.y = 5.3
  armadillo.scale.set(0.1, 0.1, 0.1);
});

// Create the main covid sphere geometry
// https://threejs.org/docs/#api/en/geometries/SphereGeometry
const sphereGeometry = new THREE.SphereGeometry(1.0, 32.0, 32.0);
const sphere = new THREE.Mesh(sphereGeometry, sphereMaterial);
scene.add(sphere);

const sphereLight = new THREE.PointLight(0xffffff, 1, 100);
scene.add(sphereLight);
sphereLight.position.set(0, 10, 0);

sphere.position.set(0, 10, 5);

// Eyes (Q1a and Q1b)
// Create the eye ball geometry
const eyeGeometry = new THREE.SphereGeometry(1.0, 32, 32);

// HINT: Replace the following with two eye ball meshes from the same geometry.
//Eg. using global scene
const rightEye = new THREE.Mesh(eyeGeometry, eyeMaterial);
rightEye.position.set(-0.8, 12.3, -4.5 + 7.6 - 8.0);
const rightEyeGlobalPos = new THREE.Vector3(-0.8, 12.3, -4.5 + 7.6 - 8.0)
rightEye.scale.set(0.5, 0.5, 0.5);
const rightEyeFrame = new THREE.Object3D();
scene.add(rightEye);

const leftEye = new THREE.Mesh(eyeGeometry, eyeMaterial);
leftEye.position.set(0.8, 12.3, -4.5 + 7.6);
leftEyeGlobalPos = new THREE.Vector3(0.8, 12.3, -4.5 + 7.6 - 8.0)
leftEye.scale.set(0.5, 0.5, 0.5);
armadilloFrame.add(leftEye); // z = -8 from origin for armadillo

// Laser Beams Q2

// Distance threshold beyond which the armadillo should shoot lasers at the sphere (needed for Q1c).
const LaserDistance = 10.0;

const laserGeometry = new THREE.CylinderGeometry(0.25, 0.25, 1.0);
const laserMaterial = new THREE.MeshPhongMaterial({ color: 0xff0000, wireframe: false });
const leftLaser = new THREE.Mesh(laserGeometry, laserMaterial);
const quaternion = new THREE.Quaternion();
quaternion.setFromAxisAngle(new THREE.Vector3(1, 0, 0), Math.PI / 2);
leftLaser.quaternion.copy(quaternion);
leftLaser.position.set(0.0, 0.0, 0.5);
const leftLaserScale = new THREE.Object3D();
leftEye.add(leftLaserScale);
leftLaserScale.add(leftLaser);

const rightLaser = new THREE.Mesh(laserGeometry, laserMaterial);
quaternion.setFromAxisAngle(new THREE.Vector3(1, 0, 0), Math.PI / 2);
rightLaser.quaternion.copy(quaternion);
rightLaser.position.set(0.0, 0.0, 0.5);
const rightLaserScale = new THREE.Object3D();
rightEye.add(rightLaserScale);
rightLaserScale.add(rightLaser);


// Listen to keyboard events.
const keyboard = new THREEx.KeyboardState();
function checkKeyboard() {

  //HINT: Use keyboard.pressed to check for keyboard input. 
  //Example: keyboard.pressed("A") to check if the A key is pressed.

  // WASDQE for move orb
  if (keyboard.pressed("W"))
    sphere.position.z -= 0.13;
  else if (keyboard.pressed("S"))
    sphere.position.z += 0.13;

  if (keyboard.pressed("A"))
    sphere.position.x -= 0.13;
  else if (keyboard.pressed("D"))
    sphere.position.x += 0.13;

  if (keyboard.pressed("E"))
    sphere.position.y += 0.13;
  else if (keyboard.pressed("Q"))
    sphere.position.y -= 0.13;

  // The following tells three.js that some uniforms might have changed.
  armadilloMaterial.needsUpdate = true;
  sphereMaterial.needsUpdate = true;
  eyeMaterial.needsUpdate = true;

  // Distance to orb
  const leftEyePos = new THREE.Vector3().setFromMatrixPosition(leftEye.matrixWorld.clone());
  const rightEyePos = new THREE.Vector3().setFromMatrixPosition(rightEye.matrixWorld.clone());
    
  if (sphere.position.distanceTo(leftEyePos) <= LaserDistance) {
    leftLaserScale.scale.set(1, 1, 2.0 * sphere.position.distanceTo(leftEyePos));
    leftLaser.visible = true;
  }
  else {
    leftLaser.visible = false;
  }
  if (sphere.position.distanceTo(rightEyePos) <= LaserDistance) {
    rightLaserScale.scale.set(1, 1, 2.0*sphere.position.distanceTo(rightEyePos));
    rightLaser.visible = true;
  } 
  else {
    rightLaser.visible = false;
  }
}

// HINT: Use one of the lookAt funcitons available in three.js to make the eyes look at the ice cream.

// Setup update callback
function update() {
  checkKeyboard();

  time.value += 1/60;//Assumes 60 frames per second
  rightEye.lookAt(sphere.position);
  leftEye.lookAt(sphere.position);
  
  // Requests the next update call, this creates a loop
  requestAnimationFrame(update);
  renderer.render(scene, camera);
}

// Start the animation loop.
update();
