import create from "zustand";

/**
 * Zustand Store
 *
 * You can add global state to the app using this AppStore, to get & set
 * values from anywhere in the app.
 *
 * Think about it as a global useState.
 */

type TAppStore = {
  cantoPrice: number;
  setCantoPrice: (newCantoPrice: number) => void;
};

export const useAppStore = create<TAppStore>(set => ({
  cantoPrice: 0,
  setCantoPrice: (newValue: number): void => set(() => ({ cantoPrice: newValue })),
}));
