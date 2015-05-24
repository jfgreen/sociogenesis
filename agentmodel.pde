import java.util.Collection;
import java.util.ArrayList;

class AgentModel {

  Collection<Agent> agents;

  AgentModel(int agentCount) {
    agents = new ArrayList();
    for(int i = 0; i < agentCount; i++) {
      PVector initalPositon = new PVector(random(width), random(height));
      float initalDirection = random(0, TWO_PI);
      agents.add(new Agent(initalPositon, initalDirection));
    }
  }

  void update() {
    for(Agent agent : agents) {
      agent.update();
    }
  }

  void draw() {
    for(Agent agent : agents) {
      agent.draw();
    }
  }
}