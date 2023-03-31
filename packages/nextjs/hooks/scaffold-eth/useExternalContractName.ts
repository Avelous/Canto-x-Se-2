import { useEffect, useState } from "react";
import { getTargetNetwork } from "~~/utils/scaffold-eth";

/**
 * @dev use this hook to get the list of contracts external by added manually to the external contracts
 * @returns {string[]} array of contract names
 */
export const useExternalContractNames = () => {
  const configuredChain = getTargetNetwork();
  const [externalContractNames, setExternalContractNames] = useState<string[]>([]);

  useEffect(() => {
    try {
      // eslint-disable-next-line @typescript-eslint/no-var-requires
      const contracts = require("~~/external/external_contracts.json");
      const contractsAtChain = contracts[`${configuredChain.id}` as keyof typeof contracts];
      const contractsData = contractsAtChain?.[0]?.contracts;
      const contractNames = contractsData ? Object.keys(contractsData) : [];

      setExternalContractNames(contractNames);
    } catch (e) {
      // File doesn't exist.
      setExternalContractNames([]);
    }
  }, [configuredChain.id]);

  return externalContractNames;
};
