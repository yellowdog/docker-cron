require 'utils'

describe "run" do
    before do
        @container_name = "tcn#{rand(1000000)}"
    end

    after do
        delete_container_with_name @container_name
    end

    def run(container_info)
        run_container_with_name(@container_name, container_info)
    end

    it "creates a new container" do
        run %{
            {
                "Image": "nginx:latest"
            }
        }

        expect(`docker ps`).to include(@container_name)
    end

    it "creates a container when an existing one already exists" do
        sh "docker run -d --rm --name #{@container_name} nginx"

        run %{
            {
                "Image": "nginx:latest"
            }
        }

        expect(`docker ps`).to include(@container_name)
    end

    it "creates a container even when no name is provided" do
        previous_container_list = `docker ps -a -q`

        run_nameless_container %{
            {
                "Image": "alpine",
                "Cmd": [
                    "echo",
                    "test"
                ]
            }
        }

        expect(`docker ps -a -q`).to satisfy do |v|
            v.length > previous_container_list.length
        end
    end
end
