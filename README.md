# Autonomous Color Sorting System Simulation  
**Team Name**: CYBER MECH INNOVATORS  
**Team Members**: Hadi Rasool A V, Karthikeyan G, Loga Prasath D

---

## 🎯 Objective  
To design an **autonomous industrial sorting system** using **mechatronics and AI-driven vision**, integrating sensors, a 6-axis robot, and dynamic conveyors to achieve **real-time color classification accuracy** and **object processing speed**. The system prioritizes **physics-based simulation**, **sensor validation**, and **scalability** to reflect real-world industrial workflows.

---

## 🛠️ Tools & Technologies
- **CoppeliaSim** – for simulation and modeling.
- **Lua scripting** – for automation and logic.
- **HSV color detection** – for image-based classification.
- **Jacobian IK** – for robotic motion planning.

---

## 🧩 System Components
- **U-shaped conveyor** (Input).
- **Proximity sensor** – detects incoming object.
- **Vision sensor** – captures image for color classification.
- **6-axis robot** – picks and places colored objects.
- **Three straight conveyors** – Red, Green, Blue outputs.

---

## ⚙️ Working Overview

1. **Object enters** U-shaped conveyor.
2. **Proximity sensor** halts conveyor.
3. **Vision sensor** captures and classifies object using HSV:
   - Red: 0–10°
   - Green: 100–140°
   - Blue: 210–270°
4. **If matched**: 6-axis robot performs pick-and-place to the respective conveyor using inverse kinematics.
5. **If unmatched**: Object continues on U-conveyor.

---

## 📊 Performance

- **Accuracy**: ≥95% (based on HSV thresholds).
- **Cycle Time**: ≤8 seconds per object.
- **Efficiency**:  
  `Efficiency = (Sorted Objects / Total Input) × 100`

---

## 🧠 Contributions

| Team Member         | Responsibility                         |
|---------------------|-----------------------------------------|
| **Hadi Rasool A V** | Simulation setup, sensor integration    |
| **Karthikeyan G**   | Robot control, kinematics, torque logic |
| **Loga Prasath D**  | AI scripting, HSV classification, validation |

---

## ✅ Conclusion  
This project delivers a **scalable, AI-powered industrial sorting simulation** that integrates real-time sensing, intelligent classification, and precision robotics. The physics-based environment and autonomous logic provide a foundation for deploying similar systems in real-world manufacturing and logistics applications.
