import { useEffect, useState } from "react";
import { useProvider } from "wagmi";
import { getTargetNetwork } from "~~/utils/scaffold-eth";

type ExternalContractType = {
  address: string;
  abi: any[];
};

/**
 * @dev use this hook to get a external contract from `yarn deploy` generated files.
 * @param contractName - name of external contract
 * @returns {ExternalContractType | undefined} object containing contract address and abi or undefined if contract is not found
 */
export const useExternalContractInfo = (contractName: string | undefined | null) => {
  const configuredChain = getTargetNetwork();
  const [externalContractData, setExternalContractData] = useState<undefined | ExternalContractType>(undefined);
  const [isLoading, setIsLoading] = useState(true);
  const provider = useProvider({ chainId: configuredChain.id });

  useEffect(() => {
    const getExternalContractInfo = async () => {
      setIsLoading(true);
      let ContractData;
      try {
        ContractData = require("~~/external/external_contracts.json");
        const contractsAtChain = ContractData[configuredChain.id as keyof typeof ContractData];
        const contractsData = contractsAtChain?.[0]?.contracts;
        const externalContract = contractsData?.[contractName as keyof typeof contractsData];

        if (!externalContract || !contractName || !provider) {
          return;
        }

        const code = await provider.getCode(externalContract.address);
        // If contract code is `0x` => no contract external on that address
        if (code === "0x" || !contractsData || !(contractName in contractsData)) {
          return;
        }
        setExternalContractData(contractsData[contractName]);
      } catch (e) {
        // Contract not external or file doesn't exist.
        setExternalContractData(undefined);
      } finally {
        setIsLoading(false);
      }
    };

    getExternalContractInfo();
  }, [configuredChain.id, contractName, provider]);

  return { data: externalContractData, isLoading };
};
