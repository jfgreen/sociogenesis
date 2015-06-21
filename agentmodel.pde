import java.util.Collection;
import java.util.ArrayList;

class AgentModel {

  Environment environment;
  Parameters parameters;

  AgentModel(Parameters parameters) {
    Collection<Agent> agents = new ArrayList();
    Collection<Pellet> pellets = new ArrayList();
    this.environment = new Environment(agents, pellets);

    for(int i = 0; i < parameters.agentCount; i++) {
      PVector initalPositon = new PVector(random(width), random(height));
      float initalDirection = random(0, TWO_PI);
      Brain brain = new Brain();
      agents.add(new Agent(initalPositon, initalDirection, brain, environment, parameters));
    }

    for(int i = 0; i < parameters.pelletCount; i++) {
      PVector initalPositon = new PVector(random(width), random(height));
      pellets.add(new Pellet(initalPositon));
    }
  }

  void update() {
    for(Agent agent : environment.agents) {
      agent.update();
    }
  }

  void draw() {
    for(Agent agent : environment.agents) {
      agent.draw();
    }
    for(Pellet pellet : environment.pellets) {
      pellet.draw();
    }
  }
}

class Environment {
    final Collection<Agent> agents;
    final Collection<Pellet> pellets;

    public Environment(Collection<Agent> agents, Collection<Pellet> pellets) {
      this.agents = agents;
      this.pellets = pellets;
    }

}