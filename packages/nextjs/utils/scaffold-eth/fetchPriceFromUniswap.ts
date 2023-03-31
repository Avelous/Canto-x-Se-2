import { Fetcher, Route, Token, WETH } from "@uniswap/sdk";
import { Provider } from "@wagmi/core";
import redstone from "redstone-api";

export const fetchPriceFromUniswap = async (provider: Provider): Promise<number> => {
  try {
    const DAI = new Token(1, "0x6B175474E89094C44Da98b954EedeAC495271d0F", 18);
    const pair = await Fetcher.fetchPairData(DAI, WETH[DAI.chainId], provider);
    const route = new Route([pair], WETH[DAI.chainId]);
    const price = parseFloat(route.midPrice.toSignificant(6));
    return price;
  } catch (error) {
    console.error("useEthPrice - Error fetching ETH price from Uniswap: ", error);
    return 0;
  }
};

export const fetchCantoPriceFromRedStone = async (): Promise<number> => {
  try {
    const price = await redstone.getPrice("CANTO");
    const cantoPrice = parseFloat(price.value.toFixed(4));
    return cantoPrice;
  } catch (error) {
    console.error("useEthPrice - Error fetching CANTO price from Redstone: ", error);
    return 0;
  }
};
