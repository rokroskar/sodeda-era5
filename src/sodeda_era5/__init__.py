from .dataset import Dataset
from .flow import Era5Flow

from tqdm import tqdm 

import click

@click.command()
def preload():
    """Preload the dataset based on the deskriptors.jsonl and store the results in S3 bucket
    """
    print("Preloading the dataset")
    dataset = Dataset("deskriptors.jsonl",Era5Flow())

    for i in tqdm(range(len(dataset))):
        data = dataset[i]
        tqdm.write(str(data))


@click.command()
@click.option("--host")
@click.option("--port",type=int)
@click.option("--root-path")
def dashboard(host, port, root_path):
    "Launch the dashboard"
    from .dashboard import demo

    demo.launch(server_port=port, server_name=host, root_path=root_path)



@click.group()
def main():
    """sodeda-era5"""
    pass


main.add_command(preload)
main.add_command(dashboard)

if __name__ == "__main__":
    main()
