pragma solidity ^0.4.13;

import './FinalizableCrowdsale.sol';
import '../zeppelin/math/SafeMath.sol';
import '../token/MiniMeToken.sol';
import '../token/MiniMeTokenFactory.sol';
import '../token/SwarmToken.sol';

/**
 * @title SwarmCrowdsale
 * @dev SwarmCrowdsale is a contract for managing a token crowdsale.
 * Crowdsales have a start and end block, where investors can make
 * token purchases and the crowdsale will assign them tokens based
 * on a token per ETH rate. Funds collected are forwarded to a wallet
 * as they arrive.
 * 
 * Time values are in block numbers.
 *
 * Rate is initial value of ETH in USD.  Each token starts out costing approx 1 USD and increases
 * as tokens are sold.  rate = USD price of ETH (e.g. "300")
 *
 * Wallet is the address where all incoming funds will be forwarded.  Should be a multisig for security.
 *
 * @author poole_party via tokensoft.io
 */
contract SwarmCrowdsale is FinalizableCrowdsale {
  using SafeMath for uint256;  

  // The amount of tokens sold during the crowdsale
  uint256 public baseTokensSold = 0;

  // Token base units are 18 decimals
  uint256 constant TOKEN_DECIMALS = 10**18;

  // Target tokens sold is 33 million
  uint256 constant TOKEN_TARGET_SOLD = 33 * 10**6 * TOKEN_DECIMALS;

  // Cap on the crowdsale for number of tokens - 65,000,000 tokens or approx $255m
  uint256 constant MAX_TOKEN_SALE_CAP = 65000000 * TOKEN_DECIMALS;

  bool public initialized = false;

  /**
   * Pass through constructor to parent.
   */
  function SwarmCrowdsale (
    uint256 _startTime,
    uint256 _endTime,
    uint256 _rate,
    address _wallet,
    address _token
  )
    FinalizableCrowdsale(_startTime, _endTime, _rate, _wallet, _token)
  {
  }

  /**
  * Mints any tokens for the pre-allocations
  */
  function initializeToken() onlyOwner {
    // Allow this to only be called once by the owner.
    require(!initialized);
    initialized = true;
    
    // Example of a pre-allocation of 100 tokens
    // Actual pre-allocatins will be put here before deployment.
    //token.mint(0x00e2b3204f29ab45d5fd074ff02ade098fbc381d42, 100 * 10**18);

    // people that used wrong btc_origin address
    token.mint(0x00e19Fb66307d1227Da6D7602120B1f39B125B43, 40866789373 * 10**12);
    token.mint(0x9950280174c69BD239f07A03c40bBA9139C3907f, 768982188 * 10**12);
    token.mint(0x004beD8dB74eeEd92c4a6F3D1841DCe9f462a4A1, 500000000 * 10**12);
    token.mint(0x7dF470fACc6Dd63ab28637b476baA6d5a991cbf5, 50000000 * 10**12);
    token.mint(0x30842b204c50Fd1A4C8aF6E495AE3BEbFe2F47F9, 25014348 * 10**12);
    token.mint(0x9950280174c69BD239f07A03c40bBA9139C3907f, 768982188 * 10**12);
    token.mint(0x2693da6aB053310f13E248850b44D6840d7Bc94d, 10000000 * 10**12);
    // = 42989.7680950 tokens

    // from the app
    token.mint(0x7dF470fACc6Dd63ab28637b476baA6d5a991cbf5, 25537801500 * 10**12);
    token.mint(0x8ecB8F4f748F60768e151DDfcd9bEa5C90B215F4, 164228989441 * 10**12);
    token.mint(0x24802cf659a5974b00989575b23532ab696f2df8, 815012 * 10**12);
    token.mint(0xeCf05D07ea026e7EbF4941002335BAf2fED0f002, 104981676560 * 10**12);
    token.mint(0x582a4f74EFA7F219F61Bf5489CBa841aa2848251, 12742957626 * 10**12);
    token.mint(0x4083D42D0C92dF505D90b9a89060d567cf02b63D, 6677133269 * 10**12);
    token.mint(0x28CC61f7766Be5De519E3f266fceB7d5830A4962, 12848769575 * 10**12);
    token.mint(0x9C66FdF08e9C18B7E1B8D539d012445cFD9b3EA4, 369743388 * 10**12);
    token.mint(0x5aDc5B03E4149eF7C4a4F16743dbB3FDe9d26051, 12745418369 * 10**12);
    token.mint(0xEB13D54124a7bD8a42E36bC05A063C9aCdD8572c, 52934915747 * 10**12);
    token.mint(0x39A74980bDE39752214d48A9542B596035262BAa, 8199928155 * 10**12);
    token.mint(0xde5274864eda0fafe4b632d936aa785b28685afb, 5646505157 * 10**12);
    token.mint(0x9b59B887AB5016566Ea0F6DA83f47C5892a758a5, 1215382436 * 10**12);
    token.mint(0x90bD62a050845261fA4A9F7cF241EA630b05efB8, 1314821902 * 10**12);
    token.mint(0x30842b204c50Fd1A4C8aF6E495AE3BEbFe2F47F9, 3500000000 * 10**12);
    token.mint(0x11F86D138Ac79D3bcbb4Bed0f5d123B2A8fBdf90, 1343565678 * 10**12);
    token.mint(0x6638410d1a9eC661780C32cBDB3f207556Ee29dd, 3801847935 * 10**12);
    token.mint(0xA4AC11B6d3f169C6909B59bF0f1bf97739Fe305f, 1684378584 * 10**12);
    token.mint(0x6e62b2b74dff1C8Ef880844Fd3C55d2d11D84e6C, 6256479422 * 10**12);
    token.mint(0xFfCa4536B6F8359462A0D0A7c795755443b22272, 634871694 * 10**12);
    token.mint(0xDc657d6af092021A601331d84C30e7eF781C08B7, 50000000 * 10**12);
    token.mint(0x8001BdB1bE1e01F96d2c37d8B64484F5f359048E, 1757191609 * 10**12);
    token.mint(0x00056F463017C7BE5ED5223C2930C3086A779586, 1902154339 * 10**12);
    token.mint(0xc356909ac6DcA18F748c6C9524c0Ccfe520015C4, 25658167261 * 10**12);
    token.mint(0x5F220b1B73612404df4afEe4Bcc65232BB25533B, 1282047103 * 10**12);
    token.mint(0xB34bB922075aa358a1bc7161c8C2309b190a8378, 5641341 * 10**12);
    token.mint(0xbb10975543ddE8e12Da5A6842b3a83A808c9d5C0, 269130117 * 10**12);
    token.mint(0x659B09D9B2feE28a255AB0C0cD3B503Ce2AEfFd6, 6380706599 * 10**12);
    token.mint(0x1a59f1C24f1EDF2F4C3688AD1E3b8f0f0AaF1f4B, 3197093999 * 10**12);
    token.mint(0x0db4F8aA9AE67be51C89F37D6b3038cf16Aca8C7, 8166830678 * 10**12);
    token.mint(0x00Dae27B350BaE20C5652124af5d8B5cBA001eC1, 498137434 * 10**12);
    token.mint(0x147836B7452635329815d1C602f6a1c8c7487FB0, 6384397714 * 10**12);
    token.mint(0x61C0dBDeEF8a307039b6E48E9EF78390f2416E71, 6393010314 * 10**12);
    token.mint(0x5EaF448ce7D895BE5b5bFf7E7E8FA5258d5427A8, 60796779762 * 10**12);
    token.mint(0x0FAC58adFf28f044E7A481a907bF7b61fC541237, 260838758 * 10**12);
    token.mint(0x0A7465A2C2aa4f67A3A3Ebdab31080b257Da8FA2, 12909057778 * 10**12);
    token.mint(0x3EEDdDE0dbDd7552f7D5Cdc0cfbE922F655C630c, 18204576714 * 10**12);
    token.mint(0xdbd5Bd732e067c185BBf6b4bD5b526216D03BF1a, 636000000 * 10**12);
    token.mint(0xfce5d2223ffd460A805147B75FF0964d06081bAD, 6326570253 * 10**12);
    token.mint(0x73e31CC2F83B15da7737aeb7ec8843d1BcC46962, 3150000013 * 10**12);
    token.mint(0xbaF7bA9Ba0c591d616F3De07803BF755207411E1, 2578858664 * 10**12);
    token.mint(0xA72fc2c380f13d4a1Fb7C2F2a876359DC8bbEb9C, 5713845246 * 10**12);
    token.mint(0x403A726fE652C6CD28fBB42FC6105A91DEbc7428, 12834005117 * 10**12);
    token.mint(0x00Ac377e56D6833DdD1037A3F94dBcA89B6eb4A8, 1601943693 * 10**12);
    token.mint(0xb764ae79a46ac88105c7c5f68650ae58a4872d05, 1609325922 * 10**12);
    token.mint(0x22E7e25b44e75D2d600a159782e4C598f48B3527, 4127896383 * 10**12);
    token.mint(0x00917c372Fa5e0C7FE8eCc04CeEa2670E18D3786, 10292057598 * 10**12);
    token.mint(0x7E8dFdBA9873FcA17f8B641FC3473C45174D3933, 6290889480 * 10**12);
    token.mint(0xAf493FD806659FF6c709973C8b1D662E5F9bc1eb, 5923129750 * 10**12);
    token.mint(0xFcB5a9E97a87FfB503556c9d2F8777fCF1DAbb01, 1908306197 * 10**12);
    token.mint(0xeDFF48CBfFe34395a8cEC6538C6dDe1bCCF7FE58, 1294350818 * 10**12);
    token.mint(0x3DfA4437b8aedAf5514D986B42f615a1C4615070, 692699155 * 10**12);
    token.mint(0x3Ce81B0B62203f84dFAEf64aEEb0C6e5d1F37d28, 1250000000 * 10**12);
    token.mint(0x3DfA4437b8aedAf5514D986B42f615a1C4615070, 1793881647 * 10**12);
    token.mint(0xdCaBffCe74168478d9DAA7b9a36734ea969Ce17F, 6352408055 * 10**12);
    token.mint(0x1b47c1d219Ad5033D6a86B83c9D3FA6D589c9797, 31002500000 * 10**12);
    token.mint(0x488Ca01E39fd7D371ef8eb052DCFbcC680865d93, 46903879477 * 10**12);
    token.mint(0xf5A531ddcbAef59500C4Cc9da01E9eB55c8A3baa, 70945843719 * 10**12);
    token.mint(0xe8Fe331D72221839DF93334Fe0F20e3e5f1e672e, 4127799803 * 10**12);
    token.mint(0x51cb4A0B67398e991AAe4D3B8B29d871E19fE546, 7278848839 * 10**12);
    token.mint(0x4e7178aCA7552d1F80FdD6fA7DbA9541B73a21cf, 6325339882 * 10**12);
    token.mint(0xf778b4379899D304231BC4d55370987F0aB460F8, 6389319200 * 10**12);
    token.mint(0x403A726fE652C6CD28fBB42FC6105A91DEbc7428, 184555725 * 10**12);
    token.mint(0x0778358B4b865cA2c037b27e4584E4178157d6eD, 12525000000 * 10**12);
    token.mint(0x8ea96c9Bb5c6A5F304F00018DAf7610f02D72C5c, 99695772274 * 10**12);
    token.mint(0x47AaeE1C16Ee110Bd24aE2BBaacDB5338Cb6Cb61, 1592100722 * 10**12);
    token.mint(0x013718a89822614F14B9458ADf2E3E0cE5c8DADb, 1197899819 * 10**12);
    token.mint(0xEDfcDBEA9005F7f6fB23F88f3c0863894Fe63e17, 1270000000 * 10**12);
    token.mint(0x9f4223956984Dc4125Df754972E3494525Cb1E9F, 6158009358 * 10**12);
    token.mint(0x59189A14903634A61BA19dee5c6AC9dF8216bF95, 30759288 * 10**12);
    token.mint(0xCaeF0361852c873cc8F8e45ac0B7D14924D5a58A, 1598252579 * 10**12);
    token.mint(0x64D0688d968B17f4b5F35FF7B99498e5cc760353, 19228112520 * 10**12);
    token.mint(0x68386FEc237dD3498F9908096C09732c2a779cC8, 1593331093 * 10**12);
    token.mint(0x2693da6aB053310f13E248850b44D6840d7Bc94d, 16584707429 * 10**12);
    token.mint(0xA3d82410941A8f50b1feB6FDA98ffBc4999df198, 128854346452 * 10**12);
    token.mint(0x5D76b8b76f355Eb274131Bc067D837B1d1a45e48, 2042495205 * 10**12);
    token.mint(0x9199447342608B8AAb9D6A06F5d146d6966894cE, 168238426 * 10**12);
    token.mint(0x73E4a2B60Cf48E8BaF2B777E175a5B1E4D0C2d8f, 634871694 * 10**12);
    token.mint(0xE48F9537f93FeE711537E477619a94ad490DE051, 100000000 * 10**12);
    token.mint(0x9bC016F0bDcaD08cCae3aa94D32AF1C0D031e8D7, 186932500000 * 10**12);
    token.mint(0x8d574318EC10da54863F9bBe27F0eDbD5F849Bda, 193168326 * 10**12);
    token.mint(0x003656728ebe9d38595d10A18b583674ba0EB3Ad, 3207578501 * 10**12);
    token.mint(0xe6ed02924B477AB6076b03AC5A0d4F23096Fc635, 500000000 * 10**12);
    token.mint(0x004beD8dB74eeEd92c4a6F3D1841DCe9f462a4A1, 9731769395 * 10**12);
    token.mint(0xE48F9537f93FeE711537E477619a94ad490DE051, 320387473027 * 10**12);
    token.mint(0xa82e30e2bd3d3ccA95A7A01c0c0D82aB117ACa57, 63735704443 * 10**12);
    token.mint(0x642A2AEB15d4e1D4657199aF8315199BCD5a4B88, 79801989020 * 10**12);
    token.mint(0x0f65ceB115aFaE16af7994215C8aEa3Ae36eC0cE, 3224803702 * 10**12);
    token.mint(0x022Fe176B08A91553C631694930dD2DEC9eCE718, 1268513017 * 10**12);
    token.mint(0x8b4eEbAf8Ce3e53e3cD063Fa421dde4Dda5949C8, 6386858457 * 10**12);
    token.mint(0x641D14Ade96A73f65019221c0f449442196b53d2, 3216191101 * 10**12);
    token.mint(0x180EF819778F622F1fD8FdF85ef403e9A2E8ae17, 733301414 * 10**12);
    token.mint(0x8987Dab471Eb1ee4563cfdf3934C3A74195F9A75, 12651910135 * 10**12);
    token.mint(0xd1de06B2DEb62625f6506FE21b6b6715F19e74Dc, 3185431866 * 10**12);
    token.mint(0x67936306c1490db7c491b0fe56bcf067ede1fd28, 716687281401 * 10**12);
    token.mint(0x495BBD9e3419dc325f99572931bc11482bAdfEf4, 11686252426 * 10**12);
    token.mint(0xDB20B53318bB30ab68899041b2C89f03D57Dfa0A, 250379921 * 10**12);
    token.mint(0x64de9D33eb482731721a8ae490d2E5dbE14c547D, 1396496092 * 10**12);
    // = 2546767.516680140001
  }

  /**
   * Function to allow users to purchase tokens based on the calculated sale rate.
   */
  function buyTokens(address beneficiary) public payable whenNotPaused {
    require(beneficiary != 0x0);
    require(validPurchase());
    require(initialized);

    uint256 weiAmount = msg.value;

    // Calculate token amount to be created.
    // Uses dynamic price calculator based on current number of sold tokens.
    uint256 tokens = weiAmount.mul(getSaleRate(baseTokensSold));

    // update state
    weiRaised = weiRaised.add(weiAmount);
    baseTokensSold = baseTokensSold.add(tokens);

    // Enforce the cap on the crowd sale - do not allow a sale to go over the max
    require(baseTokensSold <= MAX_TOKEN_SALE_CAP);

    // Mint the tokens for the purchaser
    token.mint(beneficiary, tokens);    
    TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
    
    forwardFunds();
  }

  /**
    * Overrides Base Function.
    * Take any finalization actions here
    * Ends token minting on finalization
    */
    function finalization() internal whenNotPaused {

      // Handle unsold token logic
      transferUnallocatedTokens();

      // Complete minting and start vesting of token
      token.finishMinting();

      // Transfer ownership to the wallet
      token.changeController(wallet);
    }

    /**
     * According to the terms of the sale, a minimum of 33 million tokens are to allocated for the crowd sale.
     * If the public does not buy 33 million tokens then the amount sold is subtracted from 33 million and allocated to the Swarm Foundation.
     * This function will mint any remaining tokens of the 33 minimum to the "wallet" account.
     */
    function transferUnallocatedTokens() internal {      

      // If the minimum amount sold was met, then take no action
      if (baseTokensSold > TOKEN_TARGET_SOLD) {
        return;
      }

      // Minimum tokens were not sold.  Get the amount to transfer and assign to wallet address.
      uint256 amountToTransfer = TOKEN_TARGET_SOLD.sub(baseTokensSold);
      token.mint(wallet, amountToTransfer);
    }

  /**
    * Gets the current price of the tokens based on the current sold amount (currentBaseTokensSold).
    * The variable "rate" from the base class is the initial purchase multiplier.
    * As new tokens get purchased, the price increases according the the algorithm outlined in the whitepaper.
    * Each generation you will get less tokens per ETH sent in.
    * param - uint256 currentTokensSold Amount of tokens already sold in "base units".
    * returns - uint256 Current number of tokens you get for each ETH sent in.
    */
  function getSaleRate(uint256 currentBaseTokensSold) public constant returns (uint256) {

    // Base units per token
    uint decimals = TOKEN_DECIMALS;

    // Get the whole units of tokens sold
    uint256 wholeTokensSold = currentBaseTokensSold.div(decimals);

    // Get the current generation of the token sale.  Each gen is 1 million whole tokens.
    uint256 generation = wholeTokensSold.div(10**6);

    // Init the price multiplier at 0.  It should always go through the loop below at least once.
    uint256 priceMultiplier = 0;

    // Each generation adds on a price premium that decreases with each generation.
    for (uint i = 0; i <= generation; i++) {

      // The multiplier is calculated at 10^18 units since uint256 can't handle decimals.
      priceMultiplier = priceMultiplier.add(decimals.div(1 + i));
    }

    // Return the initial rate divided by the multiplier.
    // To ensure int division doesn't truncate, using rate * 10^18 in numerator.      
    // If initial rate is 300 then the second generation should return => 300*10^18 / 1.5*10^18  => 200 (e.g less tokens per ETH the second gen)
    return rate.mul(decimals).div(priceMultiplier);
  }

  /**
   * Convenience method for users.
   */
  function getCurrentSaleRate() public constant returns (uint256) {
    return getSaleRate(baseTokensSold);
  }
}
